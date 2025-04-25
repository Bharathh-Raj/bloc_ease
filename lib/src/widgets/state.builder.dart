import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A custom builder widget for Bloc states that provides type-safe success objects.
///
/// This widget can be used instead of `BlocBuilder` to handle different states
/// of a Bloc in a type-safe manner. It provides builders for initial, loading,
/// success, and failure states.
///
/// You can provide either simple builders that receive the state data directly,
/// or state builders that receive the full state object:
///
/// ```dart
/// // Using simple builders:
/// BlocEaseStateBuilder<UserBloc, User>(
///   successBuilder: (user) => Text('Success: $user'),
///   initialBuilder: () => Text('Initial state'),
///   loadingBuilder: (message, progress) => Text('Loading: $message'),
///   failureBuilder: (message, exception, retry) => Text('Error: $message'),
/// )
///
/// // Using state builders:
/// BlocEaseStateBuilder<UserBloc, User>(
///   successStateBuilder: (state) => Text('Success: ${state.success}'),
///   initialStateBuilder: (state) => Text('Initial state'),
///   loadingStateBuilder: (state) => Text('Loading: ${state.message}'),
///   failureStateBuilder: (state) => Text('Error: ${state.message}'),
/// )
/// ```
///
/// If builders are not provided, it will fall back to the default widgets
/// configured in [BlocEaseStateWidgetProvider].
///
/// Note: Either [successBuilder] or [successStateBuilder] must be provided,
/// but not both. The same applies to other builder pairs.
class BlocEaseStateBuilder<B extends BlocBase<BlocEaseState<T>>, T> extends BlocBuilder<B, BlocEaseState<T>> {
  /// Creates a `BlocEaseStateBuilder` widget.
  ///
  /// The [successBuilder] or [successStateBuilder] is required to handle success states.
  /// Other builders are optional and will use [BlocEaseStateWidgetProvider] defaults if not provided.
  ///
  /// The [bloc] parameter is optional and will use the nearest Bloc from the context if not provided.
  /// The [buildWhen] parameter determines whether to rebuild the widget with state changes.
  BlocEaseStateBuilder({
    B? bloc,
    SuccessBuilder<T>? successBuilder,
    SuccessStateBuilder<T>? successStateBuilder,
    InitialBuilder? initialBuilder,
    InitialStateBuilder? initialStateBuilder,
    LoadingBuilder? loadingBuilder,
    LoadingStateBuilder<T>? loadingStateBuilder,
    FailureBuilder? failureBuilder,
    FailureStateBuilder<T>? failureStateBuilder,
    BlocBuilderCondition<BlocEaseState<T>>? buildWhen,
    super.key,
  }) : assert(successBuilder != null || successStateBuilder != null, 'Either successBuilder or successStateBuilder must be provided'),
       assert(!(successBuilder != null && successStateBuilder != null), 'Only one of successBuilder or successStateBuilder should be provided'),
       assert(!(initialBuilder != null && initialStateBuilder != null), 'Only one of initialBuilder or initialStateBuilder should be provided'),
       assert(!(loadingBuilder != null && loadingStateBuilder != null), 'Only one of loadingBuilder or loadingStateBuilder should be provided'),
       assert(!(failureBuilder != null && failureStateBuilder != null), 'Only one of failureBuilder or failureStateBuilder should be provided'),
       super(
            bloc: bloc,
            buildWhen: buildWhen,
            builder: (context, state) => state.when(
                  initialState: initialBuilder ??
                      () => initialStateBuilder?.call(state as InitialState<T>) ??
                          BlocEaseStateWidgetProvider.of(context)
                              .initialStateBuilder(state as InitialState<T>),
                  loadingState: loadingBuilder ??
                      ([_, __]) =>
                          loadingStateBuilder?.call(state as LoadingState<T>) ??
                          BlocEaseStateWidgetProvider.of(context)
                              .loadingStateBuilder(state as LoadingState<T>),
                  failureState: failureBuilder ??
                      ([_, __, ___]) =>
                          failureStateBuilder?.call(state as FailureState<T>) ??
                          BlocEaseStateWidgetProvider.of(context)
                              .failureStateBuilder(state as FailureState<T>),
                  successState: successBuilder ??
                      (success) => successStateBuilder!(state as SuccessState<T>),
                ));
}
