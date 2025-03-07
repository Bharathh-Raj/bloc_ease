import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

/// Caches the last state of [LoadingState], [SucceedState] & [FailedState].
/// Can access the ex states via [exLoadingState], [exSucceedState] & [exFailedState].
///
/// Automatically destroys the ex states when bloc/cubit closes. Yet we can force clear the ex states by calling [resetCache] method.
///
/// Useful to do operation based on the change in same type of state.
/// eg: Animate between [LoadingState] with [LoadingState.progress]
/// Do operation only on some update in [SucceedState]
mixin CacheExBlocEaseStateMixin<T> on BlocBase<BlocEaseState<T>> {
  LoadingState<T>? _exLoadingState;
  SucceedState<T>? _exSucceedState;
  FailedState<T>? _exFailedState;

  /// Last [LoadingState] of the bloc/cubit.
  LoadingState<T>? get exLoadingState => _exLoadingState;

  /// Last [SucceedState] of the bloc/cubit.
  SucceedState<T>? get exSucceedState => _exSucceedState;

  /// Last [FailedState] of the bloc/cubit.
  FailedState<T>? get exFailedState => _exFailedState;

  /// Last [LoadingState] of the bloc/cubit.
  T? get exSucceedObject => _exSucceedState?.success;

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
