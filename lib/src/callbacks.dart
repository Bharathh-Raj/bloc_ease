import 'package:flutter/widgets.dart';

/// Typedef for a builder function that returns a widget for the initial state.
typedef InitialBuilder = Widget Function();

/// Typedef for a builder function that returns a widget for the loading state.
///
/// - [message]: Optional message describing the loading state.
/// - [progress]: Optional progress value of the loading state.
typedef LoadingBuilder = Widget Function([String? message, double? progress]);

/// Typedef for a builder function that returns a widget for the success state.
///
/// - [success]: The success object of the state.
typedef SuccessBuilder<T> = Widget Function(T success);

/// Typedef for a builder function that returns a widget for the failure state.
///
/// - [failure]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
typedef FailureBuilder = Widget Function(
    [String? failure, dynamic exception, VoidCallback? retryCallback]);

/// Typedef for a listener function that is called for the initial state.
typedef InitialListener = VoidCallback;

/// Typedef for a listener function that is called for the loading state.
///
/// - [message]: Optional message describing the loading state.
/// - [progress]: Optional progress value of the loading state.
typedef LoadingListener = void Function([String? message, double? progress]);

/// Typedef for a listener function that is called for the success state.
///
/// - [success]: The success object of the state.
typedef SuccessListener<T> = void Function(T success);

/// Typedef for a listener function that is called for the failure state.
///
/// - [failure]: Optional message describing the failure.
/// - [exception]: Optional exception that caused the failure.
/// - [retryCallback]: Optional callback to retry the operation.
typedef FailureListener = void Function(
    [String? failure, dynamic exception, VoidCallback? retryCallback]);