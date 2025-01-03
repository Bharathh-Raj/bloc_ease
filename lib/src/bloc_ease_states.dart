import 'package:flutter/foundation.dart';

sealed class BlocEaseState<T> {
  const BlocEaseState();

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
      FailedState<T>() =>
        failedState(state.message, state.exception, state.retryCallback),
    };
  }

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
      LoadingState<T>() => loadingState == null ? orElse() : loadingState(state.message, state.progress),
      SucceedState<T>() => succeedState == null ? orElse() : succeedState(state.success),
      FailedState<T>() => failedState == null
          ? orElse()
          : failedState(state.message, state.exception, state.retryCallback),
    };
  }

  bool get isLoading => maybeWhen(orElse: () => false, loadingState: (_, __) => true);
}

class InitialState<T> extends BlocEaseState<T> {
  const InitialState();
}

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

class SucceedState<T> extends BlocEaseState<T> {
  const SucceedState(this.success);
  final T success;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SucceedState &&
          runtimeType == other.runtimeType &&
          success == other.success;

  @override
  int get hashCode => success.hashCode;
}

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
