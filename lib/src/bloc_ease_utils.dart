import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Utility class for BlocEase related functions.
class BlocEaseUtil {
  /// Waits until the `blocEaseBloc` is no longer in a loading state.
  ///
  /// This function listens to the state stream of the provided `blocEaseBloc`
  /// and completes the returned future when the state is no longer loading.
  ///
  /// - [T]: The type of the state.
  /// - [blocEaseBloc]: The BlocEase bloc whose state is being monitored.
  ///
  /// Returns a `Future` that completes with the current state when it is no longer loading.
  static Future<BlocEaseState<T>> waitUntilLoading<T>(
      StateStreamable<BlocEaseState<T>> blocEaseBloc) async {
    final completer = Completer<BlocEaseState<T>>();
    final currentState = blocEaseBloc.state;
    if (currentState is! LoadingState) {
      completer.complete(currentState);
    } else {
      StreamSubscription<BlocEaseState<T>>? blocEaseStateStream;
      blocEaseStateStream = blocEaseBloc.stream.listen((event) {
        if (!event.isLoading) {
          blocEaseStateStream?.cancel();
          completer.complete(event);
        }
      });
    }
    return completer.future;
  }
}