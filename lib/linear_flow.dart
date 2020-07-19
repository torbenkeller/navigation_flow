import 'package:flutter/material.dart';
import 'package:navigation_flow/element.dart';
import 'package:navigation_flow/navigation_flow.dart';
import 'package:navigation_flow/states.dart';

class LinearFlow<T extends FlowState> extends StatefulWidget {
  final List<FlowElement> flow;
  final T initialState;
  final BuildRoute routeBuilder;

  const LinearFlow({
    Key key,
    @required this.flow,
    @required this.initialState,
    this.routeBuilder,
  })  : assert(flow != null && flow.length > 0),
        assert(initialState != null),
        super(key: key);

  @override
  _LinearFlowState createState() => _LinearFlowState<T>();
}

class _LinearFlowState<S extends FlowState> extends State<LinearFlow> {
  GlobalKey<NavigatorState> _key = GlobalKey();
  S _state;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () async {
        _executePop();
        return false;
      },
      child: Navigator(
        key: _key,
        initialRoute: '/next',
        onGenerateRoute: (settings) {
          if (settings.name == '/next') {
            final element = widget.flow[_pageIndex];
            final routeBuilder = element.routeBuilder ??
                widget.routeBuilder ??
                (child) => MaterialPageRoute(builder: (context) => child);
            return routeBuilder(
              NavigationFlow(
                element: element,
                executeNext: _executePush,
                executePrevious: _executePop,
                state: _state,
                updateState: (S state) {
                  setState(() {
                    _state = state;
                  });
                },
                child: _PopHandler(child: element.page),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  void _executePush(BuildContext _context) {
    if (widget.flow.length == _pageIndex + 1) {
      Navigator.of(context).pop();
    } else {
      _pageIndex++;
      _key.currentState.pushNamed('/next');
    }
  }

  void _executePop() {
    if (_pageIndex > 0) {
      _pageIndex--;
      _key.currentState.pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}

class _PopHandler extends StatelessWidget {
  final Widget child;

  const _PopHandler({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          NavigationFlow.of(context).previous();
          return true;
        },
        child: child);
  }
}
