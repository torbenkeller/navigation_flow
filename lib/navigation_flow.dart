library navigation_flow;

import 'package:flutter/material.dart';
import 'package:navigation_flow/arguments.dart';
import 'package:navigation_flow/element.dart';
import 'package:navigation_flow/states.dart';

typedef UpdateFlowState<S extends FlowState> = void Function(S state);

typedef ExecutePrevious = void Function();

typedef ExecuteNext = void Function(BuildContext context);

class NavigationFlow<S extends FlowState, N extends FlowArguments, P extends FlowArguments>
    extends InheritedWidget {
  final S state;

  final UpdateFlowState<S> updateState;
  final FlowElement<N, P> _element;
  final ExecuteNext _executeNext;
  final ExecutePrevious _executePrevious;

  NavigationFlow({
    @required this.state,
    @required this.updateState,
    @required Widget child,
    @required FlowElement element,
    @required ExecuteNext executeNext,
    @required ExecutePrevious executePrevious,
  })  : this._element = element,
        this._executeNext = executeNext,
        this._executePrevious = executePrevious,
        assert(state != null),
        assert(updateState != null),
        assert(element != null),
        assert(executeNext != null),
        assert(executePrevious != null),
        assert(child != null),
        super(child: child);

  @override
  bool updateShouldNotify(NavigationFlow oldWidget) => oldWidget.state != state;

  static NavigationFlow of<S extends FlowState, N extends FlowArguments, P extends FlowArguments>(
      BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<NavigationFlow<S, N, P>>();
    return result;
  }

  void next(BuildContext context, N arguments) async {
    await _element.onNext(context, arguments);
    _executeNext(context);
  }

  void previous(BuildContext context, P arguments) async {
    await _element.onPop(context, arguments);
    _executePrevious();
  }
}

