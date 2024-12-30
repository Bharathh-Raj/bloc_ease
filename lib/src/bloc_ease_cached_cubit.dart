import 'bloc_ease_state_cache.dart';
import 'bloc_ease_cubit.dart';

class BlocEaseCachedCubit<T> extends BlocEaseCubit<T> with BlocEaseStateCache<T> {
  BlocEaseCachedCubit(super.initialState) {
    initCache();
  }

  @override
  Future<void> close() {
    resetCache();
    return super.close();
  }
}
