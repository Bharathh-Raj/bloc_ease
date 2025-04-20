import 'package:flutter/foundation.dart';

/// A sealed class representing the state of a Bloc.
///
/// This class provides methods to map and handle different states such as `InitialState`, `LoadingState`, `SuccessState`, and `FailureState`.
sealed class BlocEaseState<T> {
  const BlocEaseState();

  /// Maps the current state to a specific function based on its type.
  ///
  /// - [initialState]: Function to handle `InitialState`.
  /// - [loadingState]: Function to handle `LoadingState`.
  /// - [successState]: Function to handle `SuccessState`.
  /// - [failureState]: Function to handle `FailureState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = SuccessState<int>(42);
  /// final result = state.map(
  ///   initialState: (state) => 'Initial',
  ///   loadingState: (state) => 'Loading',
  ///   successState: (state) => 'Success: ${state.success}',
  ///   failureState: (state) => 'Failed',
  /// );
  /// print(result); // Output: Success: 42
  /// ```
  R map<R extends Object?>({
    required R Function(InitialState<T> initialState) initialState,
    required R Function(LoadingState<T> loadingState) loadingState,
    required R Function(SuccessState<T> successState) successState,
    required R Function(FailureState<T> failureState) failureState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(state),
      LoadingState<T>() => loadingState(state),
      SuccessState<T>() => successState(state),
      FailureState<T>() => failureState(state),
    };
  }

  /// Executes a specific function based on the current state.
  ///
  /// - [initialState]: Function to handle `InitialState`.
  /// - [loadingState]: Function to handle `LoadingState`.
  /// - [successState]: Function to handle `SuccessState`.
  /// - [failureState]: Function to handle `FailureState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = LoadingState<int>('Uploading in progress', 0.5);
  /// final result = state.when(
  ///   initialState: () => 'Initial',
  ///   loadingState: (message, progress) => 'Loading: $message, progress: $progress',
  ///   successState: (success) => 'Success: $success',
  ///   failureState: (message, exception, retryCallback) => 'Failed: $message',
  /// );
  /// print(result); // Output: Loading: Loading, progress: 0.5
  /// ```
  R when<R extends Object?>({
    required R Function() initialState,
    required R Function(String? message, double? progress) loadingState,
    required R Function(T successObject) successState,
    required R Function(String? failureMessage, dynamic exception,
            VoidCallback? retryCallback)
        failureState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(),
      LoadingState<T>() => loadingState(state.message, state.progress),
      SuccessState<T>() => successState(state.success),
      FailureState<T>() =>
        failureState(state.message, state.exception, state.retryCallback),
    };
  }

  /// Executes a specific function based on the current state, or a default function if the state does not match.
  ///
  /// - [orElse]: Default function to execute if no state matches.
  /// - [initialState]: Optional function to handle `InitialState`.
  /// - [loadingState]: Optional function to handle `LoadingState`.
  /// - [successState]: Optional function to handle `SuccessState`.
  /// - [failureState]: Optional function to handle `FailureState`.
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
    R Function(SuccessState<T> successState)? successState,
    R Function(FailureState<T> failureState)? failureState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() =>
        initialState == null ? orElse() : initialState(state),
      LoadingState<T>() =>
        loadingState == null ? orElse() : loadingState(state),
      SuccessState<T>() =>
        successState == null ? orElse() : successState(state),
      FailureState<T>() => failureState == null ? orElse() : failureState(state),
    };
  }

  /// Executes a specific function based on the current state, or a default function if the state does not match.
  ///
  /// - [orElse]: Default function to execute if no state matches.
  /// - [initialState]: Optional function to handle `InitialState`.
  /// - [loadingState]: Optional function to handle `LoadingState`.
  /// - [successState]: Optional function to handle `SuccessState`.
  /// - [failureState]: Optional function to handle `FailureState`.
  ///
  /// Example usage:
  /// ```dart
  /// final state = FailureState<int>('Error', Exception('Failed'));
  /// final result = state.maybeWhen(
  ///   orElse: () => 'Unknown state',
  ///   failureState: (message, exception, retryCallback) => 'Failed: $message',
  /// );
  /// print(result); // Output: Failed: Error
  /// ```
  R maybeWhen<R extends Object?>({
    required R Function() orElse,
    R Function()? initialState,
    R Function(String? message, double? progress)? loadingState,
    R Function(T successObject)? successState,
    R Function(String? failureMessage, dynamic exception,
            VoidCallback? retryCallback)?
        failureState,
  }) {
    final BlocEaseState<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState == null ? orElse() : initialState(),
      LoadingState<T>() => loadingState == null
          ? orElse()
          : loadingState(state.message, state.progress),
      SuccessState<T>() =>
        successState == null ? orElse() : successState(state.success),
      FailureState<T>() => failureState == null
          ? orElse()
          : failureState(state.message, state.exception, state.retryCallback),
    };
  }

  /// Checks if the current state is `LoadingState`.
  bool get isLoading => this is LoadingState<T>;

  /// Checks if the current state is `SuccessState`.
  bool get isSuccess => this is SuccessState<T>;

  /// Checks if the current state is `FailureState`.
  bool get isFailure => this is FailureState<T>;

  /// Checks if the current state is `InitialState`.
  bool get isInitial => this is InitialState<T>;

  /// Gets the success data if available, otherwise returns null
  T? get successData => this is SuccessState<T> ? (this as SuccessState<T>).success : null; 
  
  /// Transforms success data if state is success, otherwise returns null
  R? mapSuccessData<R>(R Function(T data) mapper) {
    return this is SuccessState<T> ? mapper((this as SuccessState<T>).success) : null;
  }
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
class SuccessState<T> extends BlocEaseState<T> {
  const SuccessState(this.success);
  final T success;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuccessState &&
          runtimeType == other.runtimeType &&
          success == other.success;

  @override
  int get hashCode => success.hashCode;
}

/// Represents the failed state of a Bloc.
///
/// - [message]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
class FailureState<T> extends BlocEaseState<T> {
  final String? message;
  final dynamic exception;
  final VoidCallback? retryCallback;

  FailureState([this.message, this.exception, this.retryCallback]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureState &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          exception == other.exception &&
          retryCallback == other.retryCallback;

  @override
  int get hashCode =>
      message.hashCode ^ exception.hashCode ^ retryCallback.hashCode;
}
