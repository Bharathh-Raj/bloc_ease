import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FourStateBloc<T> extends Cubit<FourStates<T>> {
  FourStateBloc([FourStates<T>? initialState])
      : super(initialState ?? InitialState<T>());
}

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
  LoadingState([this.progress]);

  final double? progress;
}

class SucceedState<T> implements FourStates<T> {
  SucceedState(this.successObject);
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
  final dynamic exceptionObject;
  final String? failureMessage;

  FailedState([this.exceptionObject, this.failureMessage]);
}
