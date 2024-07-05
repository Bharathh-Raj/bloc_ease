sealed class FourStates<T> {
  const FourStates();

  R map<R extends Object?>({
    required R Function() initialState,
    required R Function(double? progress) loadingState,
    required R Function(T successObject) succeedState,
    required R Function(String? failureMessage, dynamic exception) failedState,
  }) {
    final FourStates<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState(),
      LoadingState<T>() => loadingState(state.progress),
      SucceedState<T>() => succeedState(state.successObject),
      FailedState<T>() => failedState(state.failureMessage, state.exceptionObject),
    };
  }

  R mayBeMap<R extends Object?>({
    required R Function() orElse,
    R Function()? initialState,
    R Function(double? progress)? loadingState,
    R Function(T successObject)? succeedState,
    R Function(String? failureMessage, dynamic exception)? failedState,
  }) {
    final FourStates<T> state = this;
    return switch (state) {
      InitialState<T>() => initialState == null ? orElse() : initialState(),
      LoadingState<T>() => loadingState == null ? orElse() : loadingState(state.progress),
      SucceedState<T>() => succeedState == null ? orElse() : succeedState(state.successObject),
      FailedState<T>() =>
        failedState == null ? orElse() : failedState(state.failureMessage, state.exceptionObject),
    };
  }

  bool get isLoading => mayBeMap(orElse: () => false, loadingState: (_) => true);
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

  FailedState([this.failureMessage, this.exceptionObject]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedState &&
          runtimeType == other.runtimeType &&
          failureMessage == other.failureMessage &&
          exceptionObject == other.exceptionObject;

  @override
  int get hashCode => failureMessage.hashCode ^ exceptionObject.hashCode;
}
