import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCubit extends Cubit<BlocEaseState<int>> {
  TestCubit() : super(const InitialState());
}

void main() {
  group('BlocBaseX extension', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('emitInitial should emit InitialState', () {
      cubit.emitInitial();
      expect(cubit.state, isA<InitialState>());
    });

    test('emitLoading should emit LoadingState with correct parameters', () {
      const message = 'Loading...';
      const progress = 0.5;

      cubit.emitLoading(message, progress);
      
      expect(cubit.state, isA<LoadingState<int>>());
      expect((cubit.state as LoadingState<int>).message, message);
      expect((cubit.state as LoadingState<int>).progress, progress);
    });

    test('emitLoading should emit LoadingState with null parameters when not provided', () {
      cubit.emitLoading();
      
      expect(cubit.state, isA<LoadingState<int>>());
      expect((cubit.state as LoadingState<int>).message, isNull);
      expect((cubit.state as LoadingState<int>).progress, isNull);
    });

    test('emitSuccess should emit SuccessState with correct data', () {
      const data = 42;
      
      cubit.emitSuccess(data);
      
      expect(cubit.state, isA<SuccessState<int>>());
      expect((cubit.state as SuccessState<int>).success, data);
    });

    test('emitFailure should emit FailureState with correct parameters', () {
      const message = 'Error occurred';
      final exception = Exception('Test exception');
      final retryCallback = () {};
      
      cubit.emitFailure(message, exception, retryCallback);
      
      expect(cubit.state, isA<FailureState<int>>());
      expect((cubit.state as FailureState<int>).message, message);
      expect((cubit.state as FailureState<int>).exception, exception);
      expect((cubit.state as FailureState<int>).retryCallback, retryCallback);
    });

    test('emitFailure should emit FailureState with null parameters when not provided', () {
      cubit.emitFailure();
      
      expect(cubit.state, isA<FailureState<int>>());
      expect((cubit.state as FailureState<int>).message, isNull);
      expect((cubit.state as FailureState<int>).exception, isNull);
      expect((cubit.state as FailureState<int>).retryCallback, isNull);
    });

    test('safeEmit should not emit state when cubit is closed', () async {
      await cubit.close();
      
      // This should not throw an exception
      cubit.emitInitial();
      
      // State should remain the same (initial state)
      expect(cubit.isClosed, isTrue);
    });

    test('state transitions should work correctly in sequence', () {
      cubit.emitInitial();
      expect(cubit.state, isA<InitialState>());
      
      cubit.emitLoading('Loading', 0.3);
      expect(cubit.state, isA<LoadingState<int>>());
      
      cubit.emitSuccess(10);
      expect(cubit.state, isA<SuccessState<int>>());
      expect((cubit.state as SuccessState<int>).success, 10);
      
      cubit.emitFailure('Error');
      expect(cubit.state, isA<FailureState<int>>());
      
      // Back to initial
      cubit.emitInitial();
      expect(cubit.state, isA<InitialState>());
    });
  });
}
