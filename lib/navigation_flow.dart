library navigation_flow;

import 'package:flutter/material.dart';

abstract class FlowArguments {}

class EmptyFlowArguments implements FlowArguments {}

abstract class FlowState {
  int _pageIndex = 0;

  FlowState([this._pageIndex = 0]);

  int get pageIndex => _pageIndex;

  void nextPage() {
    _pageIndex++;
  }

  void popPage() {
    _pageIndex--;
  }
}

class EmptyFlowState extends FlowState {}

typedef HandleFlowEvent<T extends FlowArguments, S extends FlowState> = Future<S> Function(
    BuildContext context, T, S);

typedef OnFlowEvent<T extends FlowArguments> = Future<void> Function(
    BuildContext context, T arguments);

typedef FlowWidgetBuilder = Widget Function(OnFlowEvent onNext, OnFlowEvent onPop, FlowState state);

class FlowElement {
  final HandleFlowEvent onNext;
  final HandleFlowEvent onPop;
  final FlowWidgetBuilder builder;

  FlowElement({
    @required this.onNext,
    @required this.onPop,
    @required this.builder,
  })  : assert(onNext != null),
        assert(onPop != null),
        assert(builder != null);
}

typedef BuildRoute = Route Function(Widget child);

class LinearFlow<T extends FlowState> extends StatefulWidget {
  final List<FlowElement> flow;
  final FlowState initialState;
  final BuildRoute _buildRoute;

  BuildRoute get buildRoute =>
      _buildRoute ?? (child) => MaterialPageRoute(builder: (context) => child);

  const LinearFlow({
    Key key,
    @required this.flow,
    @required this.initialState,
    BuildRoute buildRoute,
  })  : _buildRoute = buildRoute,
        assert(flow != null && flow.length > 0),
        assert(initialState != null),
        super(key: key);

  @override
  _LinearFlowState createState() => _LinearFlowState<T>();
}

class _LinearFlowState<T extends FlowState> extends State<LinearFlow> {
  GlobalKey<NavigatorState> _key = GlobalKey();
  T _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  @override
  Widget build(BuildContext _) {
    return WillPopScope(
      onWillPop: () async {
        _state.popPage();
        if (_state.pageIndex >= 0) {
          _key.currentState.pop();
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Navigator(
        key: _key,
        initialRoute: _state.pageIndex.toString(),
        onGenerateRoute: (settings) {
          final index = int.parse(settings.name);
          final FlowElement element = widget.flow[index];

          return widget.buildRoute(
            element.builder(
              (_context, arguments) async {
                final newState = await element.onNext(_context, arguments, _state);
                _state = newState ?? _state;
                _state.nextPage();
                if (widget.flow.length == _state.pageIndex) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushNamed(_context, _state.pageIndex.toString());
                }
              },
              (_context, arguments) async {
                final newState = await element.onPop(_context, arguments, _state);
                _state = newState ?? _state;
                _state.popPage();
                if (_state.pageIndex >= 0) {
                  Navigator.of(_context).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
              _state,
            ),
          );
        },
      ),
    );
  }
}
