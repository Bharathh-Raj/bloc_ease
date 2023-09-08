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
          listener: (context, state) => state.mayBeMap(
            orElse: () => null,
            initialState: initialListener,
            loadingState: loadingListener,
            succeedState: succeedListener,
            failedState: failureListener,
          ),
          buildWhen: buildWhen,
          builder: (context, state) => state.map(
            initialState: initialBuilder ??
                BlocEaseStateWidgetsProvider.of(context).initialStateBuilder,
            loadingState: loadingBuilder ??
                BlocEaseStateWidgetsProvider.of(context).loadingStateBuilder,
            failedState: failureBuilder ??
                BlocEaseStateWidgetsProvider.of(context).failureStateBuilder,
            succeedState: succeedBuilder,
          ),
        );
}
