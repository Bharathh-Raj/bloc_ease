import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'four_state.bloc.freezed.dart';

abstract class FourStateBloc<T> extends Cubit<FourStates<T>> {
  FourStateBloc([FourStates<T>? initialState])
      : super(initialState ?? _initial<T>());
}

@freezed
class FourStates<T> with _$FourStates<T> {
  const factory FourStates.initial() = _initial<T>;
  const factory FourStates.loading([double? progress]) = _loading<T>;
  const factory FourStates.succeed(T succeedObject) = _succeed<T>;
  const factory FourStates.failed(
      [dynamic exceptionObject, String? failureMessage]) = _failed<T>;
}
