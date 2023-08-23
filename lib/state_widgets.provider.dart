import 'package:flutter/widgets.dart';

import 'callbacks.dart';

class StateWidgetsProvider extends InheritedWidget {
  const StateWidgetsProvider({
    required this.initialStateBuilder,
    required this.loadingStateBuilder,
    required this.failureStateBuilder,
    required super.child,
    super.key,
  });

  final InitialBuilder initialStateBuilder;
  final LoadingBuilder loadingStateBuilder;
  final FailureBuilder failureStateBuilder;

  static StateWidgetsProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateWidgetsProvider>();
  }

  static StateWidgetsProvider of(BuildContext context) {
    final StateWidgetsProvider? result = maybeOf(context);
    assert(result != null, 'No StateWidgetsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StateWidgetsProvider oldWidget) =>
      oldWidget.initialStateBuilder != initialStateBuilder &&
      oldWidget.loadingStateBuilder != loadingStateBuilder &&
      oldWidget.failureStateBuilder != failureStateBuilder;
}
