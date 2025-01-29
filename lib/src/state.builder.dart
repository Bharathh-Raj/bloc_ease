import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';

/// A custom builder widget for Bloc states that provides type-safe success objects.
///
/// This widget can be used instead of `BlocBuilder` to handle different states
/// of a Bloc in a type-safe manner. It provides builders for initial, loading,
/// success, and failure states, with the success state being mandatory.
///
/// Example usage:
/// ```dart
/// BlocEaseStateBuilder<UserBloc, User>(
///   succeedBuilder: (user) => Text('Success: $user');
///   initialBuilder: () => Text('Initial state');
///   loadingBuilder: ([message, progress]) => Text('Loading: $message, progress: $progress');
///   failureBuilder: (message, exception, retryCallback) => return Text('Failure: $message, exception: $exception');
/// )
/// ```
class BlocEaseStateBuilder<B extends BlocBase<BlocEaseState<T>>, T>
    extends BlocBuilder<B, BlocEaseState<T>> {
  /// Creates a `BlocEaseStateBuilder` widget.
  ///
  /// The [succeedBuilder] is a required callback that will be invoked when the
  /// state is `SucceedState`. The [initialBuilder], [loadingBuilder], and
  /// [failureBuilder] are optional callbacks. If not provided, the corresponding widgets
  /// configured in [BlocEaseStateWidgetProvider] will be used. The [bloc] parameter is optional
  /// and will use the nearest Bloc with context if not provided. The [buildWhen] parameter
  /// determines whether or not to rebuild the widget with the state.
  BlocEaseStateBuilder({
    required SuccessBuilder<T> succeedBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    B? bloc,
    BlocBuilderCondition<BlocEaseState<T>>? buildWhen,
    super.key,
  }) : super(
            bloc: bloc,
            buildWhen: buildWhen,
            builder: (context, state) => state.when(
                  initialState: initialBuilder ??
                      () => BlocEaseStateWidgetProvider.of(context)
                          .initialStateBuilder(state as InitialState<T>),
                  loadingState: loadingBuilder ??
                      ([_, __]) => BlocEaseStateWidgetProvider.of(context)
                          .loadingStateBuilder(state as LoadingState<T>),
                  failedState: failureBuilder ??
                      ([_, __, ___]) => BlocEaseStateWidgetProvider.of(context)
                          .failureStateBuilder(state as FailedState<T>),
                  succeedState: succeedBuilder,
                ));
}
