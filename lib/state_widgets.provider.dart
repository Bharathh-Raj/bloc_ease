import 'package:flutter/widgets.dart';

import 'callbacks.dart';

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
