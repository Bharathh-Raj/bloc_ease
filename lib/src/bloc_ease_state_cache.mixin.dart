import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_ease_states.dart';

mixin BlocEaseStateCacheMixin<T> on BlocBase<BlocEaseState<T>> {
  LoadingState<T>? exLoadingState;
  SucceedState<T>? exSucceedState;
  FailedState<T>? exFailedState;

  @override
  void onChange(Change<BlocEaseState<T>> change) {
    final exState = change.currentState;
    exState.maybeMap(
      orElse: () => null,
      succeedState: (succeedState) => exSucceedState = succeedState,
      loadingState: (loadingState) => exLoadingState = loadingState,
      failedState: (failedState) => exFailedState = failedState,
    );
    super.onChange(change);
  }

  @override
  Future<void> close() {
    exLoadingState = null;
    exSucceedState = null;
    exFailedState = null;
    return super.close();
  }
}
