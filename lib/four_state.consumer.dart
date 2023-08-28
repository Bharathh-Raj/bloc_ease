import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';
import 'four_states.dart';
import 'state_widgets.provider.dart';

/// Can be used instead of BlocConsumer.
/// 'succeedBuilder' is the only required param.
/// Provides success object in typesafe manner.
class FourStateConsumer<B extends BlocBase<FourStates<T>>, T>
    extends BlocConsumer<B, FourStates<T>> {
  FourStateConsumer({
    required SuccessBuilder<T> succeedBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    SuccessListener<T>? succeedListener,
    InitialListener? initialListener,
    LoadingListener? loadingListener,
    FailureListener? failureListener,
    B? bloc,
    BlocListenerCondition<FourStates<T>>? listenWhen,
    BlocBuilderCondition<FourStates<T>>? buildWhen,
    super.key,
  }) : super(
          bloc: bloc,
          listenWhen: listenWhen,
          listener: (context, state) => switch (state) {
            InitialState<T>() =>
              initialListener == null ? null : initialListener(),
            LoadingState<T>() =>
              loadingListener == null ? null : loadingListener(state.progress),
            FailedState<T>() => failureListener == null
                ? null
                : failureListener(state.failureMessage, state.exceptionObject),
            SucceedState<T>() => succeedListener == null
                ? null
                : succeedListener(state.successObject),
          },
          buildWhen: buildWhen,
          builder: (context, state) => switch (state) {
            InitialState<T>() => initialBuilder == null
                ? BlocEaseStateWidgetsProvider.of(context).initialStateBuilder()
                : initialBuilder(),
            LoadingState<T>() => loadingBuilder == null
                ? BlocEaseStateWidgetsProvider.of(context)
                    .loadingStateBuilder(state.progress)
                : loadingBuilder(state.progress),
            FailedState<T>() => failureBuilder == null
                ? BlocEaseStateWidgetsProvider.of(context).failureStateBuilder(
                    state.exceptionObject, state.failureMessage)
                : failureBuilder(state.exceptionObject, state.failureMessage),
            SucceedState<T>() => succeedBuilder(state.successObject),
          },
        );
}
