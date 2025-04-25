import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/states.dart';

/// Caches the last state of [InitialState], [LoadingState], [SuccessState] & [FailureState].
/// Can access the ex states via [exInitialState], [exLoadingState], [exSuccessState] & [exFailureState].
///
/// Note: The ex states are only updated when the state type changes. For example, if a [LoadingState] 
/// is emitted while the current state is already a [LoadingState], the [exLoadingState] won't be updated
/// until the state changes to a different type (like [SuccessState]) and then back to [LoadingState].
///
/// Automatically destroys the ex states when bloc/cubit closes. Yet we can force clear the ex states by calling [resetCache] method.
///
/// Useful to do operation based on the change in same type of state.
/// eg: Animate between [LoadingState] with [LoadingState.progress]
/// Do operation only on some update in [SuccessState]
///
/// Example usage with Cubit:
/// ```dart
/// class SearchCubit extends Cubit<BlocEaseState<List<String>>> with CacheExBlocEaseStateMixin {
///   void search(String query) {
///     emitLoading('Searching...');
///     
///     // Access previous loading state progress
///     final prevProgress = exLoadingState?.progress ?? 0;
///     
///     // Update progress based on previous value
///     emitLoading('Processing...', prevProgress + 0.2);
///     
///     // Access previous successful results
///     final prevResults = exSuccessState?.success;
///     
///     // Do something with previous results while loading new ones
///     if (prevResults != null) {
///       // Use cached results
///     }
///   }
/// }
/// ```
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
