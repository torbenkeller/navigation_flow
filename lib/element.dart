import 'package:flutter/material.dart';
import 'package:navigation_flow/arguments.dart';

typedef HandleFlowEvent<T extends FlowArguments> = Future<void> Function(BuildContext context, T);

typedef OnFlowEvent<T extends FlowArguments> = Future<void> Function(
    BuildContext context, T arguments);

typedef BuildRoute = Route Function(Widget child);

class FlowElement<N extends FlowArguments, P extends FlowArguments> {
  final HandleFlowEvent<N> onNext;
  final HandleFlowEvent<P> onPop;
  final Widget child;
  final BuildRoute routeBuilder;

  FlowElement({
    @required this.onNext,
    @required this.onPop,
    @required this.child,
    this.routeBuilder,
  })  : assert(onNext != null),
        assert(onPop != null),
        assert(child != null);

  BuildRoute get buildRoute =>
      routeBuilder ?? (child) => MaterialPageRoute(builder: (context) => child);
}
