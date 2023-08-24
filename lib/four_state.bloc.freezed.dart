// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'four_state.bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FourStates<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double? progress) loading,
    required TResult Function(T succeedObject) succeed,
    required TResult Function(String? failureMessage, dynamic exceptionObject)
        failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double? progress)? loading,
    TResult? Function(T succeedObject)? succeed,
    TResult? Function(String? failureMessage, dynamic exceptionObject)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double? progress)? loading,
    TResult Function(T succeedObject)? succeed,
    TResult Function(String? failureMessage, dynamic exceptionObject)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial<T> value) initial,
    required TResult Function(_loading<T> value) loading,
    required TResult Function(_succeed<T> value) succeed,
    required TResult Function(_failed<T> value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial<T> value)? initial,
    TResult? Function(_loading<T> value)? loading,
    TResult? Function(_succeed<T> value)? succeed,
    TResult? Function(_failed<T> value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial<T> value)? initial,
    TResult Function(_loading<T> value)? loading,
    TResult Function(_succeed<T> value)? succeed,
    TResult Function(_failed<T> value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FourStatesCopyWith<T, $Res> {
  factory $FourStatesCopyWith(
          FourStates<T> value, $Res Function(FourStates<T>) then) =
      _$FourStatesCopyWithImpl<T, $Res, FourStates<T>>;
}

/// @nodoc
class _$FourStatesCopyWithImpl<T, $Res, $Val extends FourStates<T>>
    implements $FourStatesCopyWith<T, $Res> {
  _$FourStatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_initialCopyWith<T, $Res> {
  factory _$$_initialCopyWith(
          _$_initial<T> value, $Res Function(_$_initial<T>) then) =
      __$$_initialCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$_initialCopyWithImpl<T, $Res>
    extends _$FourStatesCopyWithImpl<T, $Res, _$_initial<T>>
    implements _$$_initialCopyWith<T, $Res> {
  __$$_initialCopyWithImpl(
      _$_initial<T> _value, $Res Function(_$_initial<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_initial<T> implements _initial<T> {
  const _$_initial();

  @override
  String toString() {
    return 'FourStates<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_initial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double? progress) loading,
    required TResult Function(T succeedObject) succeed,
    required TResult Function(String? failureMessage, dynamic exceptionObject)
        failed,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double? progress)? loading,
    TResult? Function(T succeedObject)? succeed,
    TResult? Function(String? failureMessage, dynamic exceptionObject)? failed,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double? progress)? loading,
    TResult Function(T succeedObject)? succeed,
    TResult Function(String? failureMessage, dynamic exceptionObject)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial<T> value) initial,
    required TResult Function(_loading<T> value) loading,
    required TResult Function(_succeed<T> value) succeed,
    required TResult Function(_failed<T> value) failed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial<T> value)? initial,
    TResult? Function(_loading<T> value)? loading,
    TResult? Function(_succeed<T> value)? succeed,
    TResult? Function(_failed<T> value)? failed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial<T> value)? initial,
    TResult Function(_loading<T> value)? loading,
    TResult Function(_succeed<T> value)? succeed,
    TResult Function(_failed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _initial<T> implements FourStates<T> {
  const factory _initial() = _$_initial<T>;
}

/// @nodoc
abstract class _$$_loadingCopyWith<T, $Res> {
  factory _$$_loadingCopyWith(
          _$_loading<T> value, $Res Function(_$_loading<T>) then) =
      __$$_loadingCopyWithImpl<T, $Res>;
  @useResult
  $Res call({double? progress});
}

/// @nodoc
class __$$_loadingCopyWithImpl<T, $Res>
    extends _$FourStatesCopyWithImpl<T, $Res, _$_loading<T>>
    implements _$$_loadingCopyWith<T, $Res> {
  __$$_loadingCopyWithImpl(
      _$_loading<T> _value, $Res Function(_$_loading<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = freezed,
  }) {
    return _then(_$_loading<T>(
      freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$_loading<T> implements _loading<T> {
  const _$_loading([this.progress]);

  @override
  final double? progress;

  @override
  String toString() {
    return 'FourStates<$T>.loading(progress: $progress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_loading<T> &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_loadingCopyWith<T, _$_loading<T>> get copyWith =>
      __$$_loadingCopyWithImpl<T, _$_loading<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double? progress) loading,
    required TResult Function(T succeedObject) succeed,
    required TResult Function(String? failureMessage, dynamic exceptionObject)
        failed,
  }) {
    return loading(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double? progress)? loading,
    TResult? Function(T succeedObject)? succeed,
    TResult? Function(String? failureMessage, dynamic exceptionObject)? failed,
  }) {
    return loading?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double? progress)? loading,
    TResult Function(T succeedObject)? succeed,
    TResult Function(String? failureMessage, dynamic exceptionObject)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial<T> value) initial,
    required TResult Function(_loading<T> value) loading,
    required TResult Function(_succeed<T> value) succeed,
    required TResult Function(_failed<T> value) failed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial<T> value)? initial,
    TResult? Function(_loading<T> value)? loading,
    TResult? Function(_succeed<T> value)? succeed,
    TResult? Function(_failed<T> value)? failed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial<T> value)? initial,
    TResult Function(_loading<T> value)? loading,
    TResult Function(_succeed<T> value)? succeed,
    TResult Function(_failed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _loading<T> implements FourStates<T> {
  const factory _loading([final double? progress]) = _$_loading<T>;

  double? get progress;
  @JsonKey(ignore: true)
  _$$_loadingCopyWith<T, _$_loading<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_succeedCopyWith<T, $Res> {
  factory _$$_succeedCopyWith(
          _$_succeed<T> value, $Res Function(_$_succeed<T>) then) =
      __$$_succeedCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T succeedObject});
}

/// @nodoc
class __$$_succeedCopyWithImpl<T, $Res>
    extends _$FourStatesCopyWithImpl<T, $Res, _$_succeed<T>>
    implements _$$_succeedCopyWith<T, $Res> {
  __$$_succeedCopyWithImpl(
      _$_succeed<T> _value, $Res Function(_$_succeed<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? succeedObject = freezed,
  }) {
    return _then(_$_succeed<T>(
      freezed == succeedObject
          ? _value.succeedObject
          : succeedObject // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_succeed<T> implements _succeed<T> {
  const _$_succeed(this.succeedObject);

  @override
  final T succeedObject;

  @override
  String toString() {
    return 'FourStates<$T>.succeed(succeedObject: $succeedObject)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_succeed<T> &&
            const DeepCollectionEquality()
                .equals(other.succeedObject, succeedObject));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(succeedObject));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_succeedCopyWith<T, _$_succeed<T>> get copyWith =>
      __$$_succeedCopyWithImpl<T, _$_succeed<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double? progress) loading,
    required TResult Function(T succeedObject) succeed,
    required TResult Function(String? failureMessage, dynamic exceptionObject)
        failed,
  }) {
    return succeed(succeedObject);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double? progress)? loading,
    TResult? Function(T succeedObject)? succeed,
    TResult? Function(String? failureMessage, dynamic exceptionObject)? failed,
  }) {
    return succeed?.call(succeedObject);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double? progress)? loading,
    TResult Function(T succeedObject)? succeed,
    TResult Function(String? failureMessage, dynamic exceptionObject)? failed,
    required TResult orElse(),
  }) {
    if (succeed != null) {
      return succeed(succeedObject);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial<T> value) initial,
    required TResult Function(_loading<T> value) loading,
    required TResult Function(_succeed<T> value) succeed,
    required TResult Function(_failed<T> value) failed,
  }) {
    return succeed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial<T> value)? initial,
    TResult? Function(_loading<T> value)? loading,
    TResult? Function(_succeed<T> value)? succeed,
    TResult? Function(_failed<T> value)? failed,
  }) {
    return succeed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial<T> value)? initial,
    TResult Function(_loading<T> value)? loading,
    TResult Function(_succeed<T> value)? succeed,
    TResult Function(_failed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (succeed != null) {
      return succeed(this);
    }
    return orElse();
  }
}

abstract class _succeed<T> implements FourStates<T> {
  const factory _succeed(final T succeedObject) = _$_succeed<T>;

  T get succeedObject;
  @JsonKey(ignore: true)
  _$$_succeedCopyWith<T, _$_succeed<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_failedCopyWith<T, $Res> {
  factory _$$_failedCopyWith(
          _$_failed<T> value, $Res Function(_$_failed<T>) then) =
      __$$_failedCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String? failureMessage, dynamic exceptionObject});
}

/// @nodoc
class __$$_failedCopyWithImpl<T, $Res>
    extends _$FourStatesCopyWithImpl<T, $Res, _$_failed<T>>
    implements _$$_failedCopyWith<T, $Res> {
  __$$_failedCopyWithImpl(
      _$_failed<T> _value, $Res Function(_$_failed<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failureMessage = freezed,
    Object? exceptionObject = freezed,
  }) {
    return _then(_$_failed<T>(
      freezed == failureMessage
          ? _value.failureMessage
          : failureMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == exceptionObject
          ? _value.exceptionObject
          : exceptionObject // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_failed<T> implements _failed<T> {
  const _$_failed([this.failureMessage, this.exceptionObject]);

  @override
  final String? failureMessage;
  @override
  final dynamic exceptionObject;

  @override
  String toString() {
    return 'FourStates<$T>.failed(failureMessage: $failureMessage, exceptionObject: $exceptionObject)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_failed<T> &&
            (identical(other.failureMessage, failureMessage) ||
                other.failureMessage == failureMessage) &&
            const DeepCollectionEquality()
                .equals(other.exceptionObject, exceptionObject));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failureMessage,
      const DeepCollectionEquality().hash(exceptionObject));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_failedCopyWith<T, _$_failed<T>> get copyWith =>
      __$$_failedCopyWithImpl<T, _$_failed<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(double? progress) loading,
    required TResult Function(T succeedObject) succeed,
    required TResult Function(String? failureMessage, dynamic exceptionObject)
        failed,
  }) {
    return failed(failureMessage, exceptionObject);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(double? progress)? loading,
    TResult? Function(T succeedObject)? succeed,
    TResult? Function(String? failureMessage, dynamic exceptionObject)? failed,
  }) {
    return failed?.call(failureMessage, exceptionObject);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(double? progress)? loading,
    TResult Function(T succeedObject)? succeed,
    TResult Function(String? failureMessage, dynamic exceptionObject)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(failureMessage, exceptionObject);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_initial<T> value) initial,
    required TResult Function(_loading<T> value) loading,
    required TResult Function(_succeed<T> value) succeed,
    required TResult Function(_failed<T> value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_initial<T> value)? initial,
    TResult? Function(_loading<T> value)? loading,
    TResult? Function(_succeed<T> value)? succeed,
    TResult? Function(_failed<T> value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_initial<T> value)? initial,
    TResult Function(_loading<T> value)? loading,
    TResult Function(_succeed<T> value)? succeed,
    TResult Function(_failed<T> value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _failed<T> implements FourStates<T> {
  const factory _failed(
      [final String? failureMessage,
      final dynamic exceptionObject]) = _$_failed<T>;

  String? get failureMessage;
  dynamic get exceptionObject;
  @JsonKey(ignore: true)
  _$$_failedCopyWith<T, _$_failed<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
