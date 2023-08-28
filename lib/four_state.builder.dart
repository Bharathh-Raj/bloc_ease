import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';

/// Can be used instead of BlocBuilder.
/// Only need to handle success state with 'succeedBuilder' field. Initial, Loading, Failed states are all handled automatically
/// with the configuration we provided with [BlocEaseStateWidgetsProvider].
class FourStateBuilder<B extends BlocBase<FourStates<T>>, T>
    extends BlocBuilder<B, FourStates<T>> {
  FourStateBuilder({
    required SuccessBuilder<T> succeedBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    B? bloc,
    BlocBuilderCondition<FourStates<T>>? buildWhen,
    super.key,
  }) : super(
          bloc: bloc,
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
