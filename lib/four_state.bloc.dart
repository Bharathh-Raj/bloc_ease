sealed class FourStates<T> {}

class InitialState<T> implements FourStates<T> {
  const InitialState();
}

class LoadingState<T> implements FourStates<T> {
  const LoadingState([this.progress]);

  final double? progress;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingState &&
          runtimeType == other.runtimeType &&
          progress == other.progress;

  @override
  int get hashCode => progress.hashCode;
}

class SucceedState<T> implements FourStates<T> {
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

class FailedState<T> implements FourStates<T> {
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
