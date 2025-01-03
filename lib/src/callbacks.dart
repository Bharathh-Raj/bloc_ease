import 'package:flutter/widgets.dart';

typedef InitialBuilder = Widget Function();
typedef LoadingBuilder = Widget Function([String? message, double? progress]);
typedef SuccessBuilder<T> = Widget Function(T success);
typedef FailureBuilder = Widget Function(
    [String? failure, dynamic exception, VoidCallback? retryCallback]);

typedef InitialListener = VoidCallback;
typedef LoadingListener = void Function([String? message, double? progress]);
typedef SuccessListener<T> = void Function(T success);
typedef FailureListener = void Function(
    [String? failure, dynamic exception, VoidCallback? retryCallback]);
