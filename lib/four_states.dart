import 'package:flutter/foundation.dart';

sealed class FourStates<T> {
  const FourStates();

  R map<R extends Object?>({
    required R Function(InitialState<T> initialState) initialState,
    required R Function(LoadingState<T> loadingState) loadingState,
    required R Function(SucceedState<T> succeedState) succeedState,
    required R Function(FailedState<T> failedState) failedState,
  }) {
    final FourStates<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(state),
      LoadingState<T>() => loadingState(state),
      SucceedState<T>() => succeedState(state),
      FailedState<T>() => failedState(state),
    };
  }

  R when<R extends Object?>({
    required R Function() initialState,
    required R Function(double? progress) loadingState,
    required R Function(T successObject) succeedState,
    required R Function(String? failureMessage, dynamic exception, VoidCallback? retryCallback)
        failedState,
  }) {
    final FourStates<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(),
      LoadingState<T>() => loadingState(state.progress),
      SucceedState<T>() => succeedState(state.successObject),
      FailedState<T>() =>
        failedState(state.failureMessage, state.exceptionObject, state.retryCallback),
    };
  }

  R maybeMap<R extends Object?>({
    required R Function() orElse,
    R Function(InitialState<T> initialState)? initialState,
    R Function(LoadingState<T> loadingState)? loadingState,
    R Function(SucceedState<T> succeedState)? succeedState,
    R Function(FailedState<T> failedState)? failedState,
  }) {
    final FourStates<T> state = this;
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
    R Function(double? progress)? loadingState,
    R Function(T successObject)? succeedState,
    R Function(String? failureMessage, dynamic exception, VoidCallback? retryCallback)? failedState,
  }) {
    final FourStates<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState == null ? orElse() : initialState(),
      LoadingState<T>() => loadingState == null ? orElse() : loadingState(state.progress),
      SucceedState<T>() => succeedState == null ? orElse() : succeedState(state.successObject),
      FailedState<T>() => failedState == null
          ? orElse()
          : failedState(state.failureMessage, state.exceptionObject, state.retryCallback),
    };
  }

  bool get isLoading => maybeWhen(orElse: () => false, loadingState: (_) => true);
}

class InitialState<T> extends FourStates<T> {
  const InitialState();
}

class LoadingState<T> extends FourStates<T> {
  const LoadingState([this.progress]);

  final double? progress;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingState && runtimeType == other.runtimeType && progress == other.progress;

  @override
  int get hashCode => progress.hashCode;
}

class SucceedState<T> extends FourStates<T> {
  const SucceedState(this.successObject);
  final T successObject;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SucceedState &&
          runtimeType == other.runtimeType &&
          successObject == other.successObject;

  @override
  int get hashCode => successObject.hashCode;
}

class FailedState<T> extends FourStates<T> {
  final String? failureMessage;
  final dynamic exceptionObject;
  final VoidCallback? retryCallback;

  FailedState([this.failureMessage, this.exceptionObject, this.retryCallback]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedState &&
          runtimeType == other.runtimeType &&
          failureMessage == other.failureMessage &&
          exceptionObject == other.exceptionObject &&
          retryCallback == other.retryCallback;

  @override
  int get hashCode => failureMessage.hashCode ^ exceptionObject.hashCode ^ retryCallback.hashCode;
}
