import 'dart:async';

import '../bloc_ease.dart';
import 'bloc_ease_cubit.dart';

mixin BlocEaseStateCache<T> on BlocEaseCubit<T> {
  late final StreamSubscription<BlocEaseState<T>>? _stateStreamListener;
  LoadingState<T>? exLoadingState;
  SucceedState<T>? exSucceedState;
  FailedState<T>? exFailedState;

  void initCache() {
    _stateStreamListener = stream.listen((event) => event.maybeMap(
      orElse: () => null,
      succeedState: (succeedState) => exSucceedState = succeedState,
      loadingState: (loadingState) => exLoadingState = loadingState,
      failedState: (failedState) => exFailedState = failedState,
    ));
  }

  void resetCache() {
    exLoadingState = null;
    exSucceedState = null;
    exFailedState = null;
    _stateStreamListener?.cancel();
  }
}