import 'dart:async';

import 'package:flutter/material.dart';
import './arguments.dart';

typedef OnNext = FutureOr<void> Function(BuildContext context, FlowArguments);

typedef OnPrevious = FutureOr<void> Function();

typedef BuildRoute = Route Function(Widget child);

/// An element which can be passed into the flow.
class FlowElement {
  /// Will be called when you use `NavigationFlow.of<..>(context).next(.., ..)`.
  /// When you expect a specific arguments class, use `if(agruments is YOUR_ARGUMENTS)` to use the fields
  /// of your argument.
  final OnNext onNext;

  /// Will be called when you use `NavigationFlow.of<..>(context).previous()` or `Navigator.of(context).pop()`.
  final OnPrevious onPrevious;

  /// The page that gets displayed.
  final Widget page;

  /// The routeBuilder that is used when pushing a new page.
  /// The hierarchy is: FlowElement.routeBuilder > Flow.routeBuilder > MaterialPageRoute
  final BuildRoute routeBuilder;

  FlowElement({
    @required this.page,
    this.onNext,
    this.onPrevious,
    this.routeBuilder,
  }) : assert(page != null);
}
