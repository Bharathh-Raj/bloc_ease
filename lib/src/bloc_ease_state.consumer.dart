import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';
import 'bloc_ease_states.dart';
import 'state_widgets.provider.dart';

/// Can be used instead of BlocConsumer.
/// 'succeedBuilder' is the only required param.
/// Provides success object in typesafe manner.
class BlocEaseStateConsumer<B extends BlocBase<BlocEaseState<T>>, T>
    extends BlocConsumer<B, BlocEaseState<T>> {
  BlocEaseStateConsumer({
    required SuccessBuilder<T> succeedBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    SuccessListener<T>? succeedListener,
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
            succeedState: succeedListener,
            failedState: failureListener,
          ),
          buildWhen: buildWhen,
          builder: (context, state) => state.when(
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
