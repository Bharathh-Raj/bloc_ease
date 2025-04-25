import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/callbacks.dart';
import '../core/states.dart';

/// A custom listener widget for Bloc states that provides type-safe success objects.
///
/// This widget can be used instead of `BlocListener` to handle different states
/// of a Bloc in a type-safe manner. It provides callbacks for initial, loading,
/// success, and failure states.
///
/// You can provide either simple listeners that receive the state data directly,
/// or state listeners that receive the full state object:
///
/// ```dart
/// // Using simple listeners:
/// BlocEaseStateListener<UserBloc, User>(
///   shouldRunOnInit: true,
///   successListener: (user) => print('Success: $user'),
///   initialListener: () => print('Initial state'),
///   loadingListener: (message, progress) => print('Loading: $message'),
///   failureListener: (message, exception, retry) => print('Error: $message'),
///   child: YourWidget(),
/// )
///
/// // Using state listeners:
/// BlocEaseStateListener<UserBloc, User>(
///   shouldRunOnInit: true,
///   successStateListener: (state) => print('Success: ${state.success}'),
///   initialStateListener: (state) => print('Initial state'),
///   loadingStateListener: (state) => print('Loading: ${state.message}'),
///   failureStateListener: (state) => print('Error: ${state.message}'),
///   child: YourWidget(),
/// )
/// ```
///
/// Note: You can only provide one type of listener for each state (either the simple
/// listener or the state listener, but not both).
class BlocEaseStateListener<B extends BlocBase<BlocEaseState<T>>, T> extends StatefulWidget {
  /// Creates a `BlocEaseStateListener` widget.
  ///
  /// The [successListener], [initialListener], [loadingListener], and [failureListener]
  /// are optional callbacks that will be invoked when the corresponding state is emitted.
  /// Alternatively, you can use [successStateListener], [initialStateListener], 
  /// [loadingStateListener], and [failureStateListener] to access the full state objects.
  ///
  /// The [bloc] parameter is optional and will use the nearest Bloc from the context if not provided.
  /// The [listenWhen] parameter is a condition to determine whether to invoke the listener with state.
  /// The [shouldRunOnInit] parameter determines whether to run the listener on initialization.
  /// The [child] is the widget that will be rendered as a descendant of this listener.
  const BlocEaseStateListener({
    super.key,
    this.successListener,
    this.successStateListener,
    this.child,
    this.initialListener,
    this.initialStateListener,
    this.loadingListener,
    this.loadingStateListener,
    this.failureListener,
    this.failureStateListener,
    this.bloc,
    this.listenWhen,
    this.shouldRunOnInit = false,
  }) : assert(!(successListener != null && successStateListener != null), 
           'Only one of successListener or successStateListener should be provided'),
       assert(!(initialListener != null && initialStateListener != null), 
           'Only one of initialListener or initialStateListener should be provided'),
       assert(!(loadingListener != null && loadingStateListener != null), 
           'Only one of loadingListener or loadingStateListener should be provided'),
       assert(!(failureListener != null && failureStateListener != null), 
           'Only one of failureListener or failureStateListener should be provided');

  /// Determines whether to run the listener during initialization. By default, `BlocListener` triggers the listener only on subsequent state changes.
  /// Setting this to true will trigger the listener immediately upon initialization.
  final bool shouldRunOnInit;

  /// Callback to be called when the state is `SuccessState`.
  final SuccessListener<T>? successListener;

  /// Callback to be called when the state is `SuccessState` with the full state object.
  final SuccessStateListener<T>? successStateListener;

  /// The widget which will be rendered as a descendant of the `BlocListenerBase`.
  final Widget? child;

  /// Callback to be called when the state is `InitialState`.
  final InitialListener? initialListener;

  /// Callback to be called when the state is `InitialState` with the full state object.
  final InitialStateListener<T>? initialStateListener;

  /// Callback to be called when the state is `LoadingState`.
  final LoadingListener? loadingListener;

  /// Callback to be called when the state is `LoadingState` with the full state object.
  final LoadingStateListener<T>? loadingStateListener;

  /// Callback to be called when the state is `FailureState`.
  final FailureListener? failureListener;

  /// Callback to be called when the state is `FailureState` with the full state object.
  final FailureStateListener<T>? failureStateListener;

  /// Bloc to listen to. If not provided, it will use the nearest Bloc from the context.
  final B? bloc;

  /// Condition to determine whether or not to invoke listener with state.
  final BlocListenerCondition<BlocEaseState<T>>? listenWhen;

  @override
  State<BlocEaseStateListener> createState() => BlocEaseStateListenerState<B, T>();
}

class BlocEaseStateListenerState<B extends BlocBase<BlocEaseState<T>>, T> extends State<BlocEaseStateListener<B, T>> {
  @override
  void initState() {
    if (!widget.shouldRunOnInit) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = widget.bloc ?? context.read<B>();
      final state = bloc.state;
      if (state is InitialState<T>) {
        if (widget.initialListener != null) {
          widget.initialListener!();
        } else if (widget.initialStateListener != null) {
          widget.initialStateListener!(state);
        }
      } else if (state is LoadingState<T>) {
        if (widget.loadingListener != null) {
          widget.loadingListener!(state.message, state.progress);
        } else if (widget.loadingStateListener != null) {
          widget.loadingStateListener!(state);
        }
      } else if (state is FailureState<T>) {
        if (widget.failureListener != null) {
          widget.failureListener!(state.message, state.exception, state.retryCallback);
        } else if (widget.failureStateListener != null) {
          widget.failureStateListener!(state);
        }
      } else if (state is SuccessState<T>) {
        if (widget.successListener != null) {
          widget.successListener!(state.success);
        } else if (widget.successStateListener != null) {
          widget.successStateListener!(state);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, BlocEaseState<T>>(
      bloc: widget.bloc,
      listenWhen: widget.listenWhen,
      listener: (context, state) {
        if (state is InitialState<T>) {
          if (widget.initialListener != null) {
            widget.initialListener!();
          } else if (widget.initialStateListener != null) {
            widget.initialStateListener!(state);
          }
        } else if (state is LoadingState<T>) {
          if (widget.loadingListener != null) {
            widget.loadingListener!(state.message, state.progress);
          } else if (widget.loadingStateListener != null) {
            widget.loadingStateListener!(state);
          }
        } else if (state is FailureState<T>) {
          if (widget.failureListener != null) {
            widget.failureListener!(state.message, state.exception, state.retryCallback);
          } else if (widget.failureStateListener != null) {
            widget.failureStateListener!(state);
          }
        } else if (state is SuccessState<T>) {
          if (widget.successListener != null) {
            widget.successListener!(state.success);
          } else if (widget.successStateListener != null) {
            widget.successStateListener!(state);
          }
        }
      },
      child: widget.child,
    );
  }
}
