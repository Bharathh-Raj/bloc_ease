import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';
import 'callbacks.dart';

/// A custom listener widget for Bloc states that provides type-safe success objects.
///
/// This widget can be used instead of `BlocListener` to handle different states
/// of a Bloc in a type-safe manner. It provides callbacks for initial, loading,
/// success, and failure states.
/// Example usage:
/// ```dart
/// BlocEaseStateListener<UserBloc, User>(
///   shouldRunOnInit: true,
///   succeedListener: (user) => print('Success: $user'),
///   initialListener: () => print('Initial state'),
///   loadingListener: (message, progress) => print('Loading: $message, progress: $progress'),
///   failureListener: (message, exception, retryCallback) => print('Failure: $message, exception: $exception'),
/// )
/// ```
class BlocEaseStateListener<B extends BlocBase<BlocEaseState<T>>, T> extends StatefulWidget {
  /// Creates a `BlocEaseStateListener` widget.
  ///
  /// The [succeedListener], [initialListener], [loadingListener], and [failureListener]
  /// are optional callbacks that will be invoked when the corresponding state is emitted.
  /// The [bloc] parameter is optional and will use the nearest Bloc with context if not provided.
  /// The [listenWhen] parameter is a condition to determine whether or not to invoke the listener with state.
  /// The [shouldRunOnInit] parameter determines whether to run the listener on initialization.
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

  /// Determines whether to run the listener during initialization. By default, `BlocListener` triggers the listener only on subsequent state changes.
  /// Setting this to true will trigger the listener immediately upon initialization.
  final bool shouldRunOnInit;

  /// Callback to be called when the state is `SucceedState`.
  final SuccessListener<T>? succeedListener;

  /// The widget which will be rendered as a descendant of the `BlocListenerBase`.
  final Widget? child;

  /// Callback to be called when the state is `InitialState`.
  final InitialListener? initialListener;

  /// Callback to be called when the state is `LoadingState`.
  final LoadingListener? loadingListener;

  /// Callback to be called when the state is `FailedState`.
  final FailureListener? failureListener;

  /// Bloc to listen to. If not provided, it will use the nearest Bloc with context.
  final B? bloc;

  /// Condition to determine whether or not to invoke listener with state.
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
        widget.failureListener!(state.message, state.exception, state.retryCallback);
      } else if (state is SucceedState<T> && widget.succeedListener != null) {
        widget.succeedListener!(state.success);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BlocEaseState<T>>(
      bloc: widget.bloc,
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