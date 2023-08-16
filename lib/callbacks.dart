import 'package:flutter/widgets.dart';

typedef InitialBuilder = Widget Function();
typedef LoadingBuilder = Widget Function([double? progress]);
typedef SucceedBuilder<T> = Widget Function(T successObject);
typedef FailureBuilder = Widget Function(
    [dynamic exceptionObject, String? failureMessage]);
