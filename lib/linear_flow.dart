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

class _LinearFlowState<S extends FlowState> extends State<LinearFlow> with NavigatorObserver {
  S _state;
  int _pageIndex = -1;

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (widget.flow[_pageIndex]?.onPrevious != null) widget.flow[_pageIndex].onPrevious();
    if (_pageIndex == 0) {
      Navigator.of(context).pop();
    }
    _pageIndex--;
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _pageIndex++;
    print(_pageIndex.toString());
  }

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
        initialRoute: '/next',
        observers: [this],
        onGenerateRoute: (settings) {
          if (settings.name == '/next' && _pageIndex != widget.flow.length - 1) {
            final element = widget.flow[_pageIndex + 1];
            final routeBuilder = element.routeBuilder ??
                widget.routeBuilder ??
                (child) => MaterialPageRoute(builder: (context) => child);
            return routeBuilder(
              NavigationFlow(
                element: element,
                executeNext: _executePush,
                state: _state,
                updateState: (S state) {
                  setState(() {
                    _state = state;
                  });
                },
                child: element.page,
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
      navigator.pushNamed('/next');
    }
  }

  void _executePop() {
    if (_pageIndex > 0) {
      navigator.pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}
