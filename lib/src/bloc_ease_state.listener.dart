import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_ease_states.dart';
import 'callbacks.dart';

/// Can be used instead of BlocListener.
/// Provides success object in typesafe manner.
class BlocEaseStateListener<B extends BlocBase<BlocEaseState<T>>, T> extends StatefulWidget {
  const BlocEaseStateListener({
    super.key,
    this.succeedListener,
    this.child,
    this.initialListener,
    this.loadingListener,
    this.failureListener,
    this.bloc,
    this.listenWhen,
    this.shouldRunOnInit = false,
  });

  final bool shouldRunOnInit;
  final SuccessListener<T>? succeedListener;
  final Widget? child;
  final InitialListener? initialListener;
  final LoadingListener? loadingListener;
  final FailureListener? failureListener;
  final B? bloc;
  final BlocListenerCondition<BlocEaseState<T>>? listenWhen;

  @override
  State<BlocEaseStateListener> createState() => BlocEaseStateListenerState<B, T>();
}

class BlocEaseStateListenerState<B extends BlocBase<BlocEaseState<T>>, T>
    extends State<BlocEaseStateListener<B, T>> {

  @override
  void initState() {
    if (!widget.shouldRunOnInit) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = widget.bloc ?? context.read<B>();
      final state = bloc.state;
      if (state is InitialState<T> && widget.initialListener != null) {
        widget.initialListener!();
      } else if (state is LoadingState<T> && widget.loadingListener != null) {
        widget.loadingListener!(state.message, state.progress);
      } else if (state is FailedState<T> && widget.failureListener != null) {
        widget.failureListener!(state.failureMessage, state.exceptionObject, state.retryCallback);
      } else if (state is SucceedState<T> && widget.succeedListener != null) {
        widget.succeedListener!(state.successObject);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BlocEaseState<T>>(
      bloc: widget.bloc as B?,
      listenWhen: widget.listenWhen,
      listener: (context, state) => state.maybeWhen(
        orElse: () => null,
        initialState: widget.initialListener,
        loadingState: widget.loadingListener,
        succeedState: widget.succeedListener,
        failedState: widget.failureListener,
      ),
      child: widget.child,
    );
  }
}
