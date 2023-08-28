import 'package:bloc_ease/callbacks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'four_states.dart';

/// Can be used instead of BlocListener.
/// Provides success object in typesafe manner.
class FourStateListener<B extends BlocBase<FourStates<T>>, T>
    extends BlocListener<B, FourStates<T>> {
  FourStateListener({
    SuccessListener<T>? succeedListener,
    Widget? child,
    InitialListener? initialListener,
    LoadingListener? loadingListener,
    FailureListener? failureListener,
    B? bloc,
    BlocListenerCondition<FourStates<T>>? listenWhen,
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
          child: child,
        );
}
