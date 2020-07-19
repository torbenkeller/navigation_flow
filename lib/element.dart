import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigation_flow/arguments.dart';

typedef HandleFlowEvent = FutureOr<void> Function(BuildContext context, FlowArguments);

typedef OnFlowEvent = Future<void> Function(BuildContext context, FlowArguments arguments);

typedef BuildRoute = Route Function(Widget child);

/// An element which can be passed into the flow.
class FlowElement {
  /// This callback gets called when you use `NavigationFlow.of<..>(context).next(.., ..)`.
  /// When you expect a specific arguments class, use `if(agruments is YOUR_ARGUMENTS)` to use the fields
  /// of your argument.
  final HandleFlowEvent onNext;

  /// The page that gets displayed.
  final Widget page;

  /// The routeBuilder that is used when pushing a new page.
  /// The hierarchy is: FlowElement.routeBuilder > Flow.routeBuilder > MaterialPageRoute
  final BuildRoute routeBuilder;

  FlowElement({
    @required this.page,
    this.onNext,
    this.routeBuilder,
  }) : assert(page != null);
}
