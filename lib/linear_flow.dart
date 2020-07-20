import 'package:flutter/material.dart';
import 'package:navigation_flow/element.dart';
import 'package:navigation_flow/navigation_flow.dart';
import 'package:navigation_flow/states.dart';

/// Handles the linear flow of pages for you.
/// You can call the next page with `NavigationFlow.of<YOUR_STATE>(context).next(context, YOUR_ARGUMENT);`.
/// You can get the current state with `NavigationFlow.of<YOUR_STATE>(context).state;`.
/// You can update the current state with `NavigationFlow.of<YOUR_STATE>(context).updateState(NEW_STATE);`.
class LinearFlow<T extends FlowState> extends StatefulWidget {

  /// The flow of pages in order of the list. So the first element of the list is the first page in the flow
  /// and the last element is the last page in the flow.
  ///
  /// It has to he not null and contains min. 1 element.
  final List<FlowElement> flow;

  /// The initial state which you can access through `NavigationFlow.of<YOUR_STATE>(context).state;`
  ///
  /// The type of the state is not changeable so when you update the state with
  /// `NavigationFlow.of<YOUR_STATE>(context).updateState(NEW_STATE);` the type of the new state has
  /// to be the same as the type of initial state.
  final T initialState;

  /// The route for all pages. The hierarchy of the routes is
  /// `FlowElement.routeBuilder` > `LinearFlow.routeBuilder` > `MaterialPageRoute`.
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
      child: NavigationFlow(
        element: widget.flow[_pageIndex + 1],
        executeNext: _executePush,
        state: _state,
        updateState: (S state) {
          setState(() {
            _state = state;
          });
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
                element.page,
              );
            }
            return null;
          },
        ),
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
