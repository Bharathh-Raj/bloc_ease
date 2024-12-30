import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';

/// Can be used instead of BlocBuilder.
/// Only need to handle success state with 'succeedBuilder' field. Initial, Loading, Failed states are all handled automatically
/// with the configuration we provided with [BlocEaseStateWidgetsProvider].
class BlocEaseStateBuilder<B extends BlocBase<BlocEaseState<T>>, T>
    extends BlocBuilder<B, BlocEaseState<T>> {
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
                      BlocEaseStateWidgetsProvider.of(context).initialStateBuilder,
                  loadingState: loadingBuilder ??
                      BlocEaseStateWidgetsProvider.of(context).loadingStateBuilder,
                  failedState: failureBuilder ??
                      BlocEaseStateWidgetsProvider.of(context).failureStateBuilder,
                  succeedState: succeedBuilder,
                ));
}
