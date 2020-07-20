library navigation_flow;

import 'package:flutter/material.dart';
import 'package:navigation_flow/arguments.dart';
import 'package:navigation_flow/element.dart';
import 'package:navigation_flow/states.dart';

typedef UpdateFlowState<S extends FlowState> = void Function(S state);

typedef ExecuteNext = void Function(BuildContext context);

class NavigationFlow<S extends FlowState> extends InheritedWidget {
  final FlowElement _element;
  final ExecuteNext _executeNext;

  /// The current state of the NavigationFlow
  final S state;

  /// Sets the state to the passed one and
  final UpdateFlowState<S> updateState;

  NavigationFlow({
    @required this.state,
    @required this.updateState,
    @required Widget child,
    @required FlowElement element,
    @required ExecuteNext executeNext,
  })  : this._element = element,
        this._executeNext = executeNext,
        assert(state != null),
        assert(updateState != null),
        assert(element != null),
        assert(executeNext != null),
        assert(child != null),
        super(child: child);

  @override
  bool updateShouldNotify(NavigationFlow oldWidget) => oldWidget.state != state;

  static NavigationFlow<S> of<S extends FlowState>(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<NavigationFlow<S>>();
    return result;
  }

  /// Pushes the next page and calls `onNext` of the `FLowElement`.
  /// You can also use `Navigator.of(context).push('/next')` to get the next page but
  /// it's not recommended because the `onNext` function of the `FlowElement` is not called then.
  void next(BuildContext context, FlowArguments arguments) async {
    if (_element.onNext != null) await _element.onNext(context, arguments);
    _executeNext(context);
  }
}
