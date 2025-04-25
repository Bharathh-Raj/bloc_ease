import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCubit extends Cubit<BlocEaseState<int>> with StateDebounce<int> {
  TestCubit() : super(const InitialState());

  void performDebouncedAction([Duration duration = const Duration(milliseconds: 300)]) {
    debounce(() {
      emitSuccess(42);
    }, duration);
  }

  void performDebouncedActionWithError([Duration duration = const Duration(milliseconds: 300)]) {
    debounce(() {
      emitFailure('Error occurred');
    }, duration);
  }
}

void main() {
  group('StateDebounce mixin', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('debounce should delay state emission by specified duration', () async {
      // Initial state
      expect(cubit.state, isA<InitialState>());

      // Perform debounced action
      cubit.performDebouncedAction(const Duration(milliseconds: 100));
      
      // State should still be initial immediately after call
      expect(cubit.state, isA<InitialState>());
      
      // Wait for less than the debounce duration
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<InitialState>());
      
      // Wait for the debounce to complete
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state, isA<SuccessState<int>>());
      expect((cubit.state as SuccessState<int>).success, 42);
    });

    test('debounce should cancel previous timer when called again', () async {
      // Perform first debounced action with longer duration
      cubit.performDebouncedAction(const Duration(milliseconds: 300));
      
      // Immediately perform second debounced action with shorter duration
      cubit.performDebouncedActionWithError(const Duration(milliseconds: 100));
      
      // Wait for the second debounce to complete
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Should have the error state from the second call, not success from first
      expect(cubit.state, isA<FailureState<int>>());
      expect((cubit.state as FailureState<int>).message, 'Error occurred');
      
      // Wait for more than the first debounce duration to ensure it was truly cancelled
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Should still be in failure state, confirming first timer was cancelled
      expect(cubit.state, isA<FailureState<int>>());
      expect((cubit.state as FailureState<int>).message, 'Error occurred');
    });

    test('debounce should use default duration when not specified', () async {
      // Perform debounced action with default duration (300ms)
      cubit.performDebouncedAction();
      
      // Wait for less than the default debounce duration
      await Future.delayed(const Duration(milliseconds: 200));
      expect(cubit.state, isA<InitialState>());
      
      // Wait for the debounce to complete
      await Future.delayed(const Duration(milliseconds: 150));
      expect(cubit.state, isA<SuccessState<int>>());
    });

    test('debounce should not emit state when cubit is closed', () async {
      // Perform debounced action
      cubit.performDebouncedAction(const Duration(milliseconds: 100));
      
      // Close the cubit before the debounce completes
      await cubit.close();
      
      // Wait for more than the debounce duration
      await Future.delayed(const Duration(milliseconds: 150));
      
      // State should not have changed
      expect(cubit.state, isA<InitialState>());
    });

    test('close should cancel any pending debounce timers', () async {
      // Create a completer to track if the callback was executed
      final completer = Completer<bool>();
      
      // Override the debounce method to use our completer
      cubit.debounce(() {
        completer.complete(true);
      }, const Duration(milliseconds: 100));
      
      // Close the cubit before the debounce completes
      await cubit.close();
      
      // Wait for more than the debounce duration
      await Future.delayed(const Duration(milliseconds: 150));
      
      // The completer should not have been completed
      expect(completer.isCompleted, isFalse);
    });
  });
}
