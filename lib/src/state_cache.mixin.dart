import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

/// Caches the last state of [InitialState], [LoadingState], [SuccessState] & [FailureState].
/// Can access the ex states via [exInitialState], [exLoadingState], [exSuccessState] & [exFailureState].
///
/// Automatically destroys the ex states when bloc/cubit closes. Yet we can force clear the ex states by calling [resetCache] method.
///
/// Useful to do operation based on the change in same type of state.
/// eg: Animate between [LoadingState] with [LoadingState.progress]
/// Do operation only on some update in [SuccessState]
mixin CacheExBlocEaseStateMixin<T> on BlocBase<BlocEaseState<T>> {
  InitialState<T>? _exInitialState;
  LoadingState<T>? _exLoadingState;
  SuccessState<T>? _exSuccessState;
  FailureState<T>? _exFailureState;

  /// Last [InitialState] of the bloc/cubit.
  InitialState<T>? get exInitialState => _exInitialState;

  /// Last [LoadingState] of the bloc/cubit.
  LoadingState<T>? get exLoadingState => _exLoadingState;

  /// Last [SuccessState] of the bloc/cubit.
  SuccessState<T>? get exSuccessState => _exSuccessState;

  /// Last [FailureState] of the bloc/cubit.
  FailureState<T>? get exFailureState => _exFailureState;

  /// Last [SuccessState] object of the bloc/cubit.
  T? get exSucceedObject => _exSuccessState?.success;

  @override
  void onChange(Change<BlocEaseState<T>> change) {
    final exState = change.currentState;
    exState.map(
      initialState: (initialState) => _exInitialState = initialState,
      successState: (successState) => _exSuccessState = successState,
      loadingState: (loadingState) => _exLoadingState = loadingState,
      failureState: (failureState) => _exFailureState = failureState,
    );
    super.onChange(change);
  }

  void resetCache() {
    _exInitialState = null;
    _exLoadingState = null;
    _exSuccessState = null;
    _exFailureState = null;
  }

  @override
  Future<void> close() {
    resetCache();
    return super.close();
  }
}
