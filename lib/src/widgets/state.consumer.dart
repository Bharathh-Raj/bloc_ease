import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/callbacks.dart';
import '../core/states.dart';
import 'state_widget.provider.dart';

/// A custom consumer widget for Bloc states that provides type-safe success objects.
///
/// This widget can be used instead of `BlocConsumer` to handle different states
/// of a Bloc in a type-safe manner. It provides builders and listeners for initial, loading,
/// success, and failure states, with the success state being mandatory.
///
/// Example usage:
/// ```dart
/// BlocEaseStateConsumer<UserBloc, User>(
///   successListener: (user) => print('Success: $user'),
///   initialListener: () => print('Initial state'),
///   loadingListener: (message, progress) => print('Loading: $message, progress: $progress'),
///   failureListener: (message, exception, retryCallback) => print('Failure: $message, exception: $exception'),
///   successBuilder: (user) => Text('Success: $user'),
///   initialBuilder: () => Text('Initial state'),
///   loadingBuilder: ([message, progress]) => Text('Loading: $message, progress: $progress'),
///   failureBuilder: (message, exception, retryCallback) => Text('Failure: $message, exception: $exception'),
/// )
/// ```
class BlocEaseStateConsumer<B extends BlocBase<BlocEaseState<T>>, T>
    extends BlocConsumer<B, BlocEaseState<T>> {
  /// Creates a `BlocEaseStateConsumer` widget.
  ///
  /// The [successBuilder] is a required callback that will be invoked when the
  /// state is `SuccessState`. The [initialBuilder], [loadingBuilder], and
  /// [failureBuilder] are optional callbacks. If not provided, the corresponding widgets
  /// configured in [BlocEaseStateWidgetProvider] will be used. The [successListener],
  /// [initialListener], [loadingListener], and [failureListener] are optional callbacks
  /// that will be invoked when the corresponding state is emitted. The [bloc] parameter is optional
  /// and will use the nearest Bloc with context if not provided. The [listenWhen] and [buildWhen] parameters
  /// determine whether or not to invoke the listener and rebuild the widget with the state, respectively.
  BlocEaseStateConsumer({
    required SuccessBuilder<T> successBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    SuccessListener<T>? successListener,
    InitialListener? initialListener,
    LoadingListener? loadingListener,
    FailureListener? failureListener,
    B? bloc,
    BlocListenerCondition<BlocEaseState<T>>? listenWhen,
    BlocBuilderCondition<BlocEaseState<T>>? buildWhen,
    super.key,
  }) : super(
            bloc: bloc,
            listenWhen: listenWhen,
            listener: (context, state) => state.maybeWhen(
                  orElse: () => null,
                  initialState: initialListener,
                  loadingState: loadingListener,
                  successState: successListener,
                  failureState: failureListener,
                ),
            buildWhen: buildWhen,
            builder: (context, state) => state.when(
                  initialState: initialBuilder ??
                      () => BlocEaseStateWidgetProvider.of(context)
                          .initialStateBuilder(state as InitialState<T>),
                  loadingState: loadingBuilder ??
                      ([_, __]) => BlocEaseStateWidgetProvider.of(context)
                          .loadingStateBuilder(state as LoadingState<T>),
                  failureState: failureBuilder ??
                      ([_, __, ___]) => BlocEaseStateWidgetProvider.of(context)
                          .failureStateBuilder(state as FailureState<T>),
                  successState: successBuilder,
                ));
}