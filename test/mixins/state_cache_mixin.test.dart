import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_ease/src/core/states.dart';
import 'package:bloc_ease/src/mixins/state_cache.mixin.dart';

// Test Cubit that uses CacheExBlocEaseStateMixin
class TestCubit extends Cubit<BlocEaseState<int>> with CacheExBlocEaseStateMixin<int> {
  TestCubit() : super(const InitialState<int>());

  void emitInitial() => emit(const InitialState<int>());
  void emitLoading([String? message, double? progress]) => emit(LoadingState<int>(message, progress));
  void emitSuccess(int data) => emit(SuccessState<int>(data));
  void emitFailure([String? message, dynamic exception, void Function()? callback]) => emit(FailureState<int>(message, exception, callback));
  
  // Helper to expose protected method for testing
  void resetCachePublic() => resetCache();
}

void main() {
  group('CacheExBlocEaseStateMixin', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('should initialize with null ex states', () {
      expect(cubit.exInitialState, isNull);
      expect(cubit.exLoadingState, isNull);
      expect(cubit.exSuccessState, isNull);
      expect(cubit.exFailureState, isNull);
      expect(cubit.exSucceedObject, isNull);
    });

    group('caching states', () {
      test('should cache InitialState', () {
        // Initial state is already emitted in constructor
        expect(cubit.state, isA<InitialState<int>>());
        
        // Emit another state type then back to initial
        cubit.emitLoading();
        // At this point, exInitialState should be updated with the previous initial state
        expect(cubit.exInitialState, isNotNull);
        expect(cubit.exInitialState, isA<InitialState<int>>());
        
        // Going back to initial won't update exInitialState yet
        cubit.emitInitial();
        // Need to change state type again to see the cached initial state update
        cubit.emitLoading();
        expect(cubit.exInitialState, isNotNull);
        expect(cubit.exInitialState, isA<InitialState<int>>());
      });

      test('should cache LoadingState', () {
        expect(cubit.exLoadingState, isNull);
        
        const message = 'Loading...';
        const progress = 0.5;
        cubit.emitLoading(message, progress);
        // Emitting loading state won't update exLoadingState yet
        expect(cubit.exLoadingState, isNull);
        
        // Need to change state type to see the cached loading state
        cubit.emitSuccess(1);
        
        expect(cubit.exLoadingState, isNotNull);
        expect(cubit.exLoadingState, isA<LoadingState<int>>());
        expect(cubit.exLoadingState?.message, message);
        expect(cubit.exLoadingState?.progress, progress);
      });

      test('should cache SuccessState', () {
        expect(cubit.exSuccessState, isNull);
        expect(cubit.exSucceedObject, isNull);
        
        const data = 42;
        cubit.emitSuccess(data);
        // Emitting success state won't update exSuccessState yet
        expect(cubit.exSuccessState, isNull);
        expect(cubit.exSucceedObject, isNull);
        
        // Need to change state type to see the cached success state
        cubit.emitLoading();
        
        expect(cubit.exSuccessState, isNotNull);
        expect(cubit.exSuccessState, isA<SuccessState<int>>());
        expect(cubit.exSuccessState?.success, data);
        expect(cubit.exSucceedObject, data);
      });

      test('should cache FailureState', () {
        expect(cubit.exFailureState, isNull);
        
        const message = 'Error occurred';
        final exception = Exception('Test exception');
        final callback = () {};
        cubit.emitFailure(message, exception, callback);
        // Emitting failure state won't update exFailureState yet
        expect(cubit.exFailureState, isNull);
        
        // Need to change state type to see the cached failure state
        cubit.emitLoading();
        
        expect(cubit.exFailureState, isNotNull);
        expect(cubit.exFailureState, isA<FailureState<int>>());
        expect(cubit.exFailureState?.message, message);
        expect(cubit.exFailureState?.exception, exception);
        expect(cubit.exFailureState?.retryCallback, callback);
      });
    });

    test('should maintain previous states when emitting new ones', () {
      // Emit all state types in sequence
      cubit.emitInitial();
      cubit.emitLoading('Loading', 0.3);
      // At this point, exInitialState should be updated, but not exLoadingState
      expect(cubit.exInitialState, isNotNull);
      expect(cubit.exLoadingState, isNull);
      
      cubit.emitSuccess(10);
      // Now exLoadingState should be updated, but not exSuccessState
      expect(cubit.exLoadingState, isNotNull);
      expect(cubit.exSuccessState, isNull);
      
      cubit.emitFailure('Error', null, null);
      // Now exSuccessState should be updated, but not exFailureState
      expect(cubit.exSuccessState, isNotNull);
      expect(cubit.exFailureState, isNull);
      
      cubit.emitSuccess(20);
      // Now exFailureState should be updated
      expect(cubit.exFailureState, isNotNull);
      
      // Need one more state change to see the latest success state cached
      cubit.emitLoading();
      expect(cubit.exSuccessState?.success, 20);
    });

    test('should update cache when state type changes', () {
      // Initial loading state
      cubit.emitLoading('Loading step 1', 0.2);
      // exLoadingState is still null because we haven't changed state type
      expect(cubit.exLoadingState, isNull);
      
      // Change to success state
      cubit.emitSuccess(100);
      // Now exLoadingState should be updated
      expect(cubit.exLoadingState?.message, 'Loading step 1');
      expect(cubit.exLoadingState?.progress, 0.2);
      
      // Change back to loading state with new values
      cubit.emitLoading('Loading step 2', 0.5);
      // exSuccessState should be updated, but exLoadingState still has old values
      expect(cubit.exSuccessState?.success, 100);
      expect(cubit.exLoadingState?.message, 'Loading step 1');
      expect(cubit.exLoadingState?.progress, 0.2);
      
      // Change to success state again with new value
      cubit.emitSuccess(200);
      // Now exLoadingState should be updated with the latest loading state
      expect(cubit.exLoadingState?.message, 'Loading step 2');
      expect(cubit.exLoadingState?.progress, 0.5);
      // But exSuccessState still has old value until we change state type again
      expect(cubit.exSuccessState?.success, 100);
    });

    test('should update ex state when emitting same state type', () {
      // Initial loading state
      cubit.emitLoading('Loading step 1', 0.2);
      // exLoadingState should still be null after first loading state
      expect(cubit.exLoadingState, isNull);
      
      // Emit another loading state without changing type
      cubit.emitLoading('Loading step 2', 0.5);
      
      // Current state should be updated
      expect(cubit.state, isA<LoadingState<int>>());
      expect((cubit.state as LoadingState<int>).message, 'Loading step 2');
      expect((cubit.state as LoadingState<int>).progress, 0.5);
      
      // exLoadingState should now be updated with the previous loading state
      expect(cubit.exLoadingState, isNotNull);
      expect(cubit.exLoadingState?.message, 'Loading step 1');
      expect(cubit.exLoadingState?.progress, 0.2);
      
      // Change state type
      cubit.emitSuccess(1);
      // exLoadingState should now have the most recent loading state
      expect(cubit.exLoadingState?.message, 'Loading step 2');
      expect(cubit.exLoadingState?.progress, 0.5);
    });

    test('should clear cache when resetCache is called', () {
      // Populate all caches by changing state types
      cubit.emitInitial();
      cubit.emitLoading();
      cubit.emitSuccess(42);
      cubit.emitFailure();
      cubit.emitInitial();
      
      // Verify all caches are populated
      expect(cubit.exLoadingState, isNotNull);
      expect(cubit.exSuccessState, isNotNull);
      expect(cubit.exFailureState, isNotNull);
      
      // Reset cache
      cubit.resetCachePublic();
      
      // All caches should be null
      expect(cubit.exInitialState, isNull);
      expect(cubit.exLoadingState, isNull);
      expect(cubit.exSuccessState, isNull);
      expect(cubit.exFailureState, isNull);
      expect(cubit.exSucceedObject, isNull);
    });

    test('should clear cache when close is called', () async {
      // Populate all caches by changing state types
      cubit.emitInitial();
      cubit.emitLoading();
      cubit.emitSuccess(42);
      cubit.emitFailure();
      cubit.emitInitial();
      
      // Verify caches are populated
      expect(cubit.exLoadingState, isNotNull);
      expect(cubit.exSuccessState, isNotNull);
      expect(cubit.exFailureState, isNotNull);
      
      // Close the cubit
      await cubit.close();
      
      // All caches should be null
      expect(cubit.exInitialState, isNull);
      expect(cubit.exLoadingState, isNull);
      expect(cubit.exSuccessState, isNull);
      expect(cubit.exFailureState, isNull);
      expect(cubit.exSucceedObject, isNull);
    });

    test('exSucceedObject should always match exSuccessState.success', () {
      expect(cubit.exSucceedObject, isNull);
      expect(cubit.exSuccessState?.success, isNull);
      
      // Emit success state
      const data = 42;
      cubit.emitSuccess(data);
      // exSuccessState and exSucceedObject are still null until state type changes
      expect(cubit.exSucceedObject, isNull);
      expect(cubit.exSuccessState, isNull);
      
      // Change state type to see the cached success state
      cubit.emitLoading();
      expect(cubit.exSucceedObject, data);
      expect(cubit.exSuccessState?.success, data);
      
      // Emit another success state
      const newData = 100;
      cubit.emitSuccess(newData);
      // exSuccessState and exSucceedObject still have old values
      expect(cubit.exSucceedObject, data);
      expect(cubit.exSuccessState?.success, data);
      
      // Change state type again to see the updated cached success state
      cubit.emitLoading();
      expect(cubit.exSucceedObject, newData);
      expect(cubit.exSuccessState?.success, newData);
    });
  });
}