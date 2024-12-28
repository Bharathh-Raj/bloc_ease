import 'package:bloc_ease/callbacks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_ease_states.dart';

/// Can be used instead of BlocListener.
/// Provides success object in typesafe manner.
class BlocEaseStateListener<B extends BlocBase<BlocEaseState<T>>, T>
    extends BlocListener<B, BlocEaseState<T>> {
  BlocEaseStateListener({
    SuccessListener<T>? succeedListener,
    Widget? child,
    InitialListener? initialListener,
    LoadingListener? loadingListener,
    FailureListener? failureListener,
    B? bloc,
    BlocListenerCondition<BlocEaseState<T>>? listenWhen,
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
          child: child,
        );
}
