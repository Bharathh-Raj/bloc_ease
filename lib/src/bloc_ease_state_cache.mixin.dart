import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_ease_states.dart';

/// Caches the last state of [LoadingState], [SucceedState] & [FailedState].
/// Can access the ex states via [exLoadingState], [exSucceedState] & [exFailedState].
///
/// Automatically destroys the ex states when bloc/cubit closes. Yet we can force clear the ex states by calling [resetCache] method.
///
/// Useful to do operation based on the change in same type of state.
/// eg: Animate between [LoadingState] with [LoadingState.progress]
/// Do operation only on some update in [SucceedState]
mixin BlocEaseStateCacheMixin<T> on BlocBase<BlocEaseState<T>> {
  LoadingState<T>? _exLoadingState;
  SucceedState<T>? _exSucceedState;
  FailedState<T>? _exFailedState;

  LoadingState<T>? get exLoadingState => _exLoadingState;
  SucceedState<T>? get exSucceedState => _exSucceedState;
  FailedState<T>? get exFailedState => _exFailedState;

  @override
  void onChange(Change<BlocEaseState<T>> change) {
    final exState = change.currentState;
    exState.maybeMap(
      orElse: () => null,
      succeedState: (succeedState) => _exSucceedState = succeedState,
      loadingState: (loadingState) => _exLoadingState = loadingState,
      failedState: (failedState) => _exFailedState = failedState,
    );
    super.onChange(change);
  }

  void resetCache() {
    _exLoadingState = null;
    _exSucceedState = null;
    _exFailedState = null;
  }

  @override
  Future<void> close() {
    resetCache();
    return super.close();
  }
}
