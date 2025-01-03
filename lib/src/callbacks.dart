import 'package:flutter/widgets.dart';

typedef InitialBuilder = Widget Function();
typedef LoadingBuilder = Widget Function([String? message, double? progress]);
typedef SuccessBuilder<T> = Widget Function(T successObject);
typedef FailureBuilder = Widget Function(
    [String? failureMessage, dynamic exception, VoidCallback? retryCallback]);

typedef InitialListener = VoidCallback;
typedef LoadingListener = void Function([String? message, double? progress]);
typedef SuccessListener<T> = void Function(T successObject);
typedef FailureListener = void Function(
    [String? failureMessage, dynamic exception, VoidCallback? retryCallback]);
