import 'package:flutter/widgets.dart';

import 'states.dart';

/// Typedef for a builder function that returns a widget for the initial state.
typedef InitialBuilder = Widget Function();

/// Typedef for a builder function that returns a widget for the initial state with a generic type.
///
/// This typedef defines a function signature for building a widget
/// when the state is in its initial state with a generic type.
///
/// - [T]: The type of the state.
/// - [initialState]: The initial state object.
typedef InitialStateBuilder<T> = Widget Function(InitialState<T> initialState);

/// Typedef for a builder function that returns a widget for the loading state.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a loading state.
///
/// - [message]: Optional message describing the loading state.
/// - [progress]: Optional progress value of the loading state.
typedef LoadingBuilder = Widget Function([String? message, double? progress]);

/// Typedef for a builder function that returns a widget for the loading state with a generic type.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a loading state with a generic type.
///
/// - [T]: The type of the state.
/// - [loadingState]: The loading state object.
typedef LoadingStateBuilder<T> = Widget Function(LoadingState<T> loadingState);

/// Typedef for a builder function that returns a widget for the success state.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a success state.
///
/// - [T]: The type of the success object.
/// - [success]: The success object of the state.
typedef SuccessBuilder<T> = Widget Function(T success);

/// Typedef for a builder function that returns a widget for the success state with a generic type.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a success state with a generic type.
///
/// - [T]: The type of the state.
/// - [successState]: The success state object.
typedef SuccessStateBuilder<T> = Widget Function(SuccessState<T> successState);

/// Typedef for a builder function that returns a widget for the failure state.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a failure state.
///
/// - [message]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
typedef FailureBuilder = Widget Function([String? message, dynamic exception, VoidCallback? retryCallback]);

/// Typedef for a builder function that returns a widget for the failure state with a generic type.
///
/// This typedef defines a function signature for building a widget
/// when the state is in a failure state with a generic type.
///
/// - [T]: The type of the state.
/// - [failureState]: The failure state object.
typedef FailureStateBuilder<T> = Widget Function(FailureState<T> failureState);

/// Typedef for a listener function that is called for the initial state.
///
/// This typedef defines a function signature for a listener function
/// that is called when the state is in its initial state.
typedef InitialListener = VoidCallback;

/// Typedef for a listener function that is called for the loading state.
///
/// This typedef defines a function signature for a listener function
/// that is called when the state is in a loading state.
///
/// - [message]: Optional message describing the loading state.
/// - [progress]: Optional progress value of the loading state.
typedef LoadingListener = void Function([String? message, double? progress]);

/// Typedef for a listener function that is called for the success state.
///
/// This typedef defines a function signature for a listener function
/// that is called when the state is in a success state.
///
/// - [T]: The type of the success object.
/// - [success]: The success object of the state.
typedef SuccessListener<T> = void Function(T success);

/// Typedef for a listener function that is called for the failure state.
///
/// This typedef defines a function signature for a listener function
/// that is called when the state is in a failure state.
///
/// - [message]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
typedef FailureListener = void Function([String? message, dynamic exception, VoidCallback? retryCallback]);
