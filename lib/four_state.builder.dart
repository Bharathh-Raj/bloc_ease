import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';

class FourStateBuilder<B extends BlocBase<FourStates<T>>, T>
    extends BlocBuilder<B, FourStates<T>> {
  FourStateBuilder({
    required SucceedBuilder<T> succeedBuilder,
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
                ? StateWidgetsProvider.of(context).initialStateBuilder()
                : initialBuilder(),
            LoadingState<T>() => loadingBuilder == null
                ? StateWidgetsProvider.of(context)
                    .loadingStateBuilder(state.progress)
                : loadingBuilder(state.progress),
            FailedState<T>() => failureBuilder == null
                ? StateWidgetsProvider.of(context).failureStateBuilder(
                    state.exceptionObject, state.failureMessage)
                : failureBuilder(state.exceptionObject, state.failureMessage),
            SucceedState<T>() => succeedBuilder(state.successObject),
          },
        );
}
