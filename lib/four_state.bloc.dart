sealed class FourStates<T> {
  factory FourStates.initial() => InitialState<T>();
  factory FourStates.loading([double? progress]) => LoadingState<T>(progress);
  factory FourStates.succeed(T succeedObject) => SucceedState<T>(succeedObject);
  factory FourStates.failed(
          [dynamic exceptionObject, String? failureMessage]) =>
      FailedState<T>(exceptionObject, failureMessage);
}

class InitialState<T> implements FourStates<T> {}

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
