import 'package:flutter/foundation.dart';

/// A sealed class representing the state of a Bloc.
///
/// This class provides methods to map and handle different states such as `InitialState`, `LoadingState`, `SucceedState`, and `FailedState`.
sealed class BlocEaseState<T> {
  const BlocEaseState();

  /// Maps the current state to a specific function based on its type.
  ///
  /// - [initialState]: Function to handle `InitialState`.
  /// - [loadingState]: Function to handle `LoadingState`.
  /// - [succeedState]: Function to handle `SucceedState`.
  /// - [failedState]: Function to handle `FailedState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = SucceedState<int>(42);
  /// final result = state.map(
  ///   initialState: (state) => 'Initial',
  ///   loadingState: (state) => 'Loading',
  ///   succeedState: (state) => 'Success: ${state.success}',
  ///   failedState: (state) => 'Failed',
  /// );
  /// print(result); // Output: Success: 42
  /// ```
  R map<R extends Object?>({
    required R Function(InitialState<T> initialState) initialState,
    required R Function(LoadingState<T> loadingState) loadingState,
    required R Function(SucceedState<T> succeedState) succeedState,
    required R Function(FailedState<T> failedState) failedState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(state),
      LoadingState<T>() => loadingState(state),
      SucceedState<T>() => succeedState(state),
      FailedState<T>() => failedState(state),
    };
  }

  /// Executes a specific function based on the current state.
  ///
  /// - [initialState]: Function to handle `InitialState`.
  /// - [loadingState]: Function to handle `LoadingState`.
  /// - [succeedState]: Function to handle `SucceedState`.
  /// - [failedState]: Function to handle `FailedState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = LoadingState<int>('Uploading in progress', 0.5);
  /// final result = state.when(
  ///   initialState: () => 'Initial',
  ///   loadingState: (message, progress) => 'Loading: $message, progress: $progress',
  ///   succeedState: (success) => 'Success: $success',
  ///   failedState: (message, exception, retryCallback) => 'Failed: $message',
  /// );
  /// print(result); // Output: Loading: Loading, progress: 0.5
  /// ```
  R when<R extends Object?>({
    required R Function() initialState,
    required R Function(String? message, double? progress) loadingState,
    required R Function(T successObject) succeedState,
    required R Function(String? failureMessage, dynamic exception, VoidCallback? retryCallback)
        failedState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(),
      LoadingState<T>() => loadingState(state.message, state.progress),
      SucceedState<T>() => succeedState(state.success),
      FailedState<T>() => failedState(state.message, state.exception, state.retryCallback),
    };
  }

  /// Executes a specific function based on the current state, or a default function if the state does not match.
  ///
  /// - [orElse]: Default function to execute if no state matches.
  /// - [initialState]: Optional function to handle `InitialState`.
  /// - [loadingState]: Optional function to handle `LoadingState`.
  /// - [succeedState]: Optional function to handle `SucceedState`.
  /// - [failedState]: Optional function to handle `FailedState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = InitialState<int>();
  /// final result = state.maybeMap(
  ///   orElse: () => 'Unknown state',
  ///   initialState: (state) => 'Initial',
  /// );
  /// print(result); // Output: Initial
  /// ```
  R maybeMap<R extends Object?>({
    required R Function() orElse,
    R Function(InitialState<T> initialState)? initialState,
    R Function(LoadingState<T> loadingState)? loadingState,
    R Function(SucceedState<T> succeedState)? succeedState,
    R Function(FailedState<T> failedState)? failedState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState == null ? orElse() : initialState(state),
      LoadingState<T>() => loadingState == null ? orElse() : loadingState(state),
      SucceedState<T>() => succeedState == null ? orElse() : succeedState(state),
      FailedState<T>() => failedState == null ? orElse() : failedState(state),
    };
  }

  /// Executes a specific function based on the current state, or a default function if the state does not match.
  ///
  /// - [orElse]: Default function to execute if no state matches.
  /// - [initialState]: Optional function to handle `InitialState`.
  /// - [loadingState]: Optional function to handle `LoadingState`.
  /// - [succeedState]: Optional function to handle `SucceedState`.
  /// - [failedState]: Optional function to handle `FailedState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = FailedState<int>('Error', Exception('Failed'));
  /// final result = state.maybeWhen(
  ///   orElse: () => 'Unknown state',
  ///   failedState: (message, exception, retryCallback) => 'Failed: $message',
  /// );
  /// print(result); // Output: Failed: Error
  /// ```
  R maybeWhen<R extends Object?>({
    required R Function() orElse,
    R Function()? initialState,
    R Function(String? message, double? progress)? loadingState,
    R Function(T successObject)? succeedState,
    R Function(String? failureMessage, dynamic exception, VoidCallback? retryCallback)? failedState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState == null ? orElse() : initialState(),
      LoadingState<T>() =>
        loadingState == null ? orElse() : loadingState(state.message, state.progress),
      SucceedState<T>() => succeedState == null ? orElse() : succeedState(state.success),
      FailedState<T>() => failedState == null
          ? orElse()
          : failedState(state.message, state.exception, state.retryCallback),
    };
  }

  /// Checks if the current state is `LoadingState`.
  bool get isLoading => maybeWhen(orElse: () => false, loadingState: (_, __) => true);
}

/// Represents the initial state of a Bloc.
class InitialState<T> extends BlocEaseState<T> {
  const InitialState();
}

/// Represents the loading state of a Bloc.
///
/// - [message]: Optional message describing the loading state.
/// - [progress]: Optional progress value of the loading state.
class LoadingState<T> extends BlocEaseState<T> {
  const LoadingState([this.message, this.progress]);

  final String? message;
  final double? progress;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingState &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          progress == other.progress;

  @override
  int get hashCode => message.hashCode ^ progress.hashCode;
}

/// Represents the success state of a Bloc.
///
/// - [success]: The success object of the state.
class SucceedState<T> extends BlocEaseState<T> {
  const SucceedState(this.success);
  final T success;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SucceedState && runtimeType == other.runtimeType && success == other.success;

  @override
  int get hashCode => success.hashCode;
}

/// Represents the failed state of a Bloc.
///
/// - [message]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
class FailedState<T> extends BlocEaseState<T> {
  final String? message;
  final dynamic exception;
  final VoidCallback? retryCallback;

  FailedState([this.message, this.exception, this.retryCallback]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedState &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          exception == other.exception &&
          retryCallback == other.retryCallback;

  @override
  int get hashCode => message.hashCode ^ exception.hashCode ^ retryCallback.hashCode;
}
