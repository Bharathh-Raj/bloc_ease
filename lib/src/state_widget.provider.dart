import 'package:flutter/widgets.dart';

import 'callbacks.dart';

/// Provides default widgets for `InitialState`, `LoadingState`, and `FailureState`.
///
/// This widget should be wrapped around the [MaterialApp] to ensure that all pages and widgets
/// have access to the default state widgets. It allows configuring the default widgets for these states
/// for its widget sub-tree.
///
/// - [initialStateBuilder] should be provided with a default widget that will be rendered for `InitialState` in [BlocEaseStateBuilder] || [BLocEaseStateConsumer].
/// - [loadingStateBuilder] should be provided with a default widget that will be rendered for `LoadingState` in [BlocEaseStateBuilder] || [BLocEaseStateConsumer].
/// - [failureStateBuilder] should be provided with a default widget that will be rendered for `FailureState` in [BlocEaseStateBuilder] || [BLocEaseStateConsumer].
class BlocEaseStateWidgetProvider extends InheritedWidget {
  const BlocEaseStateWidgetProvider({
    required this.initialStateBuilder,
    required this.loadingStateBuilder,
    required this.failureStateBuilder,
    required super.child,
    super.key,
  });

  /// Default widget builder for the `InitialState`.
  final InitialStateBuilder initialStateBuilder;

  /// Default widget builder for the `LoadingState`.
  final LoadingStateBuilder loadingStateBuilder;

  /// Default widget builder for the `FailureState`.
  final FailureStateBuilder failureStateBuilder;

  static BlocEaseStateWidgetProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlocEaseStateWidgetProvider>();
  }

  static BlocEaseStateWidgetProvider of(BuildContext context) {
    final BlocEaseStateWidgetProvider? result = maybeOf(context);
    assert(result != null, 'No BlocEaseStateWidgetProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BlocEaseStateWidgetProvider oldWidget) =>
      oldWidget.initialStateBuilder != initialStateBuilder &&
      oldWidget.loadingStateBuilder != loadingStateBuilder &&
      oldWidget.failureStateBuilder != failureStateBuilder;
}

/// Extension on [BuildContext] to easily access the default state builders.
extension ContextX on BuildContext {
  /// Retrieves the default `InitialState` builder from the nearest [BlocEaseStateWidgetProvider].
  InitialStateBuilder get initialStateWidget =>
      BlocEaseStateWidgetProvider.of(this).initialStateBuilder;

  /// Retrieves the default `LoadingState` builder from the nearest [BlocEaseStateWidgetProvider].
  LoadingStateBuilder get loadingStateWidget =>
      BlocEaseStateWidgetProvider.of(this).loadingStateBuilder;

  /// Retrieves the default `FailureState` builder from the nearest [BlocEaseStateWidgetProvider].
  FailureStateBuilder get failureStateWidget =>
      BlocEaseStateWidgetProvider.of(this).failureStateBuilder;
}
