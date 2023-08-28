import 'package:flutter/widgets.dart';

import 'callbacks.dart';

/// Used to configure default widget for InitialState, LoadingState and FailedState.
/// Wrap over any widget to change the default widgets for these states for its widget sub-tree.
///
/// Make sure to wrap this widget over the [MaterialApp], so that all pages and widgets can have access to this.
class BlocEaseStateWidgetsProvider extends InheritedWidget {
  const BlocEaseStateWidgetsProvider({
    required this.initialStateBuilder,
    required this.loadingStateBuilder,
    required this.failureStateBuilder,
    required super.child,
    super.key,
  });

  final InitialBuilder initialStateBuilder;
  final LoadingBuilder loadingStateBuilder;
  final FailureBuilder failureStateBuilder;

  static BlocEaseStateWidgetsProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlocEaseStateWidgetsProvider>();
  }

  static BlocEaseStateWidgetsProvider of(BuildContext context) {
    final BlocEaseStateWidgetsProvider? result = maybeOf(context);
    assert(result != null, 'No StateWidgetsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BlocEaseStateWidgetsProvider oldWidget) =>
      oldWidget.initialStateBuilder != initialStateBuilder &&
      oldWidget.loadingStateBuilder != loadingStateBuilder &&
      oldWidget.failureStateBuilder != failureStateBuilder;
}

extension ContextX on BuildContext {
  InitialBuilder get initialStateWidget =>
      BlocEaseStateWidgetsProvider.of(this).initialStateBuilder;
  LoadingBuilder get loadingStateWidget =>
      BlocEaseStateWidgetsProvider.of(this).loadingStateBuilder;
  FailureBuilder get failedStateWidget =>
      BlocEaseStateWidgetsProvider.of(this).failureStateBuilder;
}
