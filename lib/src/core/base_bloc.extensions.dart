import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc_ease.dart';

extension BlocBaseX<T> on BlocBase<BlocEaseState<T>> {
  /// Safely emits a state, checking if the bloc is closed
  void safeEmit(BlocEaseState<T> state) {
    if (!isClosed) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      emit(state);
    }
  }

  /// Emits an initial state
  void emitInitial() {
    safeEmit(const InitialState());
  }

  /// Emits a loading state with optional message and progress
  void emitLoading([String? message, double? progress]) {
    safeEmit(LoadingState<T>(message, progress));
  }

  /// Emits a success state with the given data
  void emitSuccess(T data) {
    safeEmit(SuccessState<T>(data));
  }

  /// Emits a failure state with optional message and exception
  void emitFailure([String? message, dynamic exception, VoidCallback? retryCallback]) {
    safeEmit(FailureState<T>(message, exception, retryCallback));
  }
}