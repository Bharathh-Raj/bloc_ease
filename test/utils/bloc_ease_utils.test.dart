import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCubit extends Cubit<BlocEaseState<int>> {
  TestCubit() : super(const InitialState());
  
  void emitLoadingState() {
    emit(const LoadingState('Loading...', 0.5));
  }
  
  void emitSuccessState() {
    emit(const SuccessState(42));
  }
  
  void emitFailureState() {
    emit(FailureState('Error occurred'));
  }
}

void main() {
  group('BlocEaseUtil', () {
    group('waitUntilLoading', () {
      late TestCubit cubit;

      setUp(() {
        cubit = TestCubit();
      });

      tearDown(() async {
        await cubit.close();
      });

      test('should complete immediately when state is not loading', () async {
        // Arrange
        cubit.emitSuccessState();
        
        // Act
        final result = await BlocEaseUtil.waitUntilLoading(cubit);
        
        // Assert
        expect(result, isA<SuccessState<int>>());
        expect((result as SuccessState<int>).success, 42);
      });

      test('should wait until state changes from loading to non-loading', () async {
        // Arrange
        cubit.emitLoadingState();
        
        // Schedule a state change after a delay
        Future.delayed(const Duration(milliseconds: 100), () {
          cubit.emitSuccessState();
        });
        
        // Act
        final result = await BlocEaseUtil.waitUntilLoading(cubit);
        
        // Assert
        expect(result, isA<SuccessState<int>>());
        expect((result as SuccessState<int>).success, 42);
      });

      test('should handle transition from loading to failure state', () async {
        // Arrange
        cubit.emitLoadingState();
        
        // Schedule a state change after a delay
        Future.delayed(const Duration(milliseconds: 100), () {
          cubit.emitFailureState();
        });
        
        // Act
        final result = await BlocEaseUtil.waitUntilLoading(cubit);
        
        // Assert
        expect(result, isA<FailureState<int>>());
        expect((result as FailureState<int>).message, 'Error occurred');
      });

      test('should not leak subscriptions when completed', () async {
        // Arrange
        cubit.emitLoadingState();
        
        // Schedule a state change after a delay
        Future.delayed(const Duration(milliseconds: 100), () {
          cubit.emitSuccessState();
        });
        
        // Act
        await BlocEaseUtil.waitUntilLoading(cubit);
        
        // Emit another loading state
        cubit.emitLoadingState();
        
        // Schedule another state change
        Future.delayed(const Duration(milliseconds: 100), () {
          cubit.emitFailureState();
        });
        
        // Act again
        final result = await BlocEaseUtil.waitUntilLoading(cubit);
        
        // Assert
        expect(result, isA<FailureState<int>>());
      });
    });
  });
}
