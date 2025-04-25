import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_ease/src/core/states.dart';

void main() {
  group('BlocEaseState', () {
    group('InitialState', () {
      test('should be correctly identified by type check', () {
        const state = InitialState<int>();
        
        expect(state.isInitial, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.isSuccess, isFalse);
        expect(state.isFailure, isFalse);
      });
    });

    group('LoadingState', () {
      test('should be correctly identified by type check', () {
        const state = LoadingState<int>();
        
        expect(state.isInitial, isFalse);
        expect(state.isLoading, isTrue);
        expect(state.isSuccess, isFalse);
        expect(state.isFailure, isFalse);
      });

      test('should store message and progress values', () {
        const message = 'Loading data';
        const progress = 0.5;
        const state = LoadingState<int>(message, progress);
        
        expect(state.message, message);
        expect(state.progress, progress);
      });

      test('should correctly handle equality', () {
        const state1 = LoadingState<int>('Loading', 0.5);
        const state2 = LoadingState<int>('Loading', 0.5);
        const state3 = LoadingState<int>('Different', 0.5);
        
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });
    });

    group('SuccessState', () {
      test('should be correctly identified by type check', () {
        const state = SuccessState<int>(42);
        
        expect(state.isInitial, isFalse);
        expect(state.isLoading, isFalse);
        expect(state.isSuccess, isTrue);
        expect(state.isFailure, isFalse);
      });

      test('should store success data', () {
        const data = 42;
        const state = SuccessState<int>(data);
        
        expect(state.success, data);
        expect(state.successData, data);
      });

      test('should correctly handle equality', () {
        const state1 = SuccessState<int>(42);
        const state2 = SuccessState<int>(42);
        const state3 = SuccessState<int>(43);
        
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });
    });

    group('FailureState', () {
      test('should be correctly identified by type check', () {
        final state = FailureState<int>();
        
        expect(state.isInitial, isFalse);
        expect(state.isLoading, isFalse);
        expect(state.isSuccess, isFalse);
        expect(state.isFailure, isTrue);
      });

      test('should store error information', () {
        const message = 'Error message';
        final exception = Exception('Test exception');
        final callback = () {};
        final state = FailureState<int>(message, exception, callback);
        
        expect(state.message, message);
        expect(state.exception, exception);
        expect(state.retryCallback, callback);
      });

      test('should correctly handle equality', () {
        final callback = () {};
        final exception = Exception('Test');
        final state1 = FailureState<int>('Error', exception, callback);
        final state2 = FailureState<int>('Error', exception, callback);
        final state3 = FailureState<int>('Different', exception, callback);
        
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });
    });

    group('map method', () {
      test('should call initialState function for InitialState', () {
        const state = InitialState<int>();
        final result = state.map(
          initialState: (_) => 'initial',
          loadingState: (_) => 'loading',
          successState: (_) => 'success',
          failureState: (_) => 'failure',
        );
        
        expect(result, 'initial');
      });

      test('should call loadingState function for LoadingState', () {
        const state = LoadingState<int>('Loading', 0.5);
        final result = state.map(
          initialState: (_) => 'initial',
          loadingState: (_) => 'loading',
          successState: (_) => 'success',
          failureState: (_) => 'failure',
        );
        
        expect(result, 'loading');
      });

      test('should call successState function for SuccessState', () {
        const state = SuccessState<int>(42);
        final result = state.map(
          initialState: (_) => 'initial',
          loadingState: (_) => 'loading',
          successState: (_) => 'success',
          failureState: (_) => 'failure',
        );
        
        expect(result, 'success');
      });

      test('should call failureState function for FailureState', () {
        final state = FailureState<int>('Error');
        final result = state.map(
          initialState: (_) => 'initial',
          loadingState: (_) => 'loading',
          successState: (_) => 'success',
          failureState: (_) => 'failure',
        );
        
        expect(result, 'failure');
      });
    });

    group('when method', () {
      test('should call initialState function for InitialState', () {
        const state = InitialState<int>();
        final result = state.when(
          initialState: () => 'initial',
          loadingState: (message, progress) => 'loading',
          successState: (data) => 'success',
          failureState: (message, exception, callback) => 'failure',
        );
        
        expect(result, 'initial');
      });

      test('should call loadingState function with correct params for LoadingState', () {
        const message = 'Loading';
        const progress = 0.5;
        const state = LoadingState<int>(message, progress);
        
        String? capturedMessage;
        double? capturedProgress;
        
        final result = state.when(
          initialState: () => 'initial',
          loadingState: (msg, prog) {
            capturedMessage = msg;
            capturedProgress = prog;
            return 'loading';
          },
          successState: (data) => 'success',
          failureState: (message, exception, callback) => 'failure',
        );
        
        expect(result, 'loading');
        expect(capturedMessage, message);
        expect(capturedProgress, progress);
      });

      test('should call successState function with correct data for SuccessState', () {
        const data = 42;
        const state = SuccessState<int>(data);
        
        int? capturedData;
        
        final result = state.when(
          initialState: () => 'initial',
          loadingState: (message, progress) => 'loading',
          successState: (value) {
            capturedData = value;
            return 'success';
          },
          failureState: (message, exception, callback) => 'failure',
        );
        
        expect(result, 'success');
        expect(capturedData, data);
      });

      test('should call failureState function with correct params for FailureState', () {
        const message = 'Error';
        final exception = Exception('Test');
        final callback = () {};
        final state = FailureState<int>(message, exception, callback);
        
        String? capturedMessage;
        dynamic capturedException;
        void Function()? capturedCallback;
        
        final result = state.when(
          initialState: () => 'initial',
          loadingState: (message, progress) => 'loading',
          successState: (data) => 'success',
          failureState: (msg, exc, cb) {
            capturedMessage = msg;
            capturedException = exc;
            capturedCallback = cb;
            return 'failure';
          },
        );
        
        expect(result, 'failure');
        expect(capturedMessage, message);
        expect(capturedException, exception);
        expect(capturedCallback, callback);
      });
    });

    group('maybeMap method', () {
      test('should call initialState function for InitialState when provided', () {
        const state = InitialState<int>();
        final result = state.maybeMap(
          orElse: () => 'orElse',
          initialState: (_) => 'initial',
        );
        
        expect(result, 'initial');
      });

      test('should call orElse function for InitialState when initialState not provided', () {
        const state = InitialState<int>();
        final result = state.maybeMap(
          orElse: () => 'orElse',
        );
        
        expect(result, 'orElse');
      });

      test('should handle all state types correctly', () {
        const initial = InitialState<int>();
        const loading = LoadingState<int>();
        const success = SuccessState<int>(42);
        final failure = FailureState<int>();
        
        expect(
          initial.maybeMap(
            orElse: () => 'orElse',
            initialState: (_) => 'initial',
            loadingState: (_) => 'loading',
          ),
          'initial',
        );
        
        expect(
          loading.maybeMap(
            orElse: () => 'orElse',
            loadingState: (_) => 'loading',
            successState: (_) => 'success',
          ),
          'loading',
        );
        
        expect(
          success.maybeMap(
            orElse: () => 'orElse',
            successState: (_) => 'success',
            failureState: (_) => 'failure',
          ),
          'success',
        );
        
        expect(
          failure.maybeMap(
            orElse: () => 'orElse',
            failureState: (_) => 'failure',
            initialState: (_) => 'initial',
          ),
          'failure',
        );
      });
    });

    group('maybeWhen method', () {
      test('should call initialState function for InitialState when provided', () {
        const state = InitialState<int>();
        final result = state.maybeWhen(
          orElse: () => 'orElse',
          initialState: () => 'initial',
        );
        
        expect(result, 'initial');
      });

      test('should call orElse function for InitialState when initialState not provided', () {
        const state = InitialState<int>();
        final result = state.maybeWhen(
          orElse: () => 'orElse',
        );
        
        expect(result, 'orElse');
      });

      test('should handle all state types correctly with parameters', () {
        const initial = InitialState<int>();
        const loading = LoadingState<int>('Loading', 0.5);
        const success = SuccessState<int>(42);
        final exception = Exception('Test');
        final callback = () {};
        final failure = FailureState<int>('Error', exception, callback);
        
        String? capturedLoadingMessage;
        double? capturedProgress;
        int? capturedData;
        String? capturedErrorMessage;
        dynamic capturedException;
        void Function()? capturedCallback;
        
        expect(
          initial.maybeWhen(
            orElse: () => 'orElse',
            initialState: () => 'initial',
          ),
          'initial',
        );
        
        expect(
          loading.maybeWhen(
            orElse: () => 'orElse',
            loadingState: (msg, prog) {
              capturedLoadingMessage = msg;
              capturedProgress = prog;
              return 'loading';
            },
          ),
          'loading',
        );
        expect(capturedLoadingMessage, 'Loading');
        expect(capturedProgress, 0.5);
        
        expect(
          success.maybeWhen(
            orElse: () => 'orElse',
            successState: (data) {
              capturedData = data;
              return 'success';
            },
          ),
          'success',
        );
        expect(capturedData, 42);
        
        expect(
          failure.maybeWhen(
            orElse: () => 'orElse',
            failureState: (msg, exc, cb) {
              capturedErrorMessage = msg;
              capturedException = exc;
              capturedCallback = cb;
              return 'failure';
            },
          ),
          'failure',
        );
        expect(capturedErrorMessage, 'Error');
        expect(capturedException, exception);
        expect(capturedCallback, callback);
      });
    });

    group('successData getter', () {
      test('should return success data for SuccessState', () {
        const data = 42;
        const state = SuccessState<int>(data);
        
        expect(state.successData, data);
      });

      test('should return null for non-SuccessState', () {
        const initialState = InitialState<int>();
        const loadingState = LoadingState<int>();
        final failureState = FailureState<int>();
        
        expect(initialState.successData, isNull);
        expect(loadingState.successData, isNull);
        expect(failureState.successData, isNull);
      });
    });

    group('mapSuccessData method', () {
      test('should transform success data for SuccessState', () {
        const data = 42;
        const state = SuccessState<int>(data);
        
        final result = state.mapSuccessData((value) => value * 2);
        
        expect(result, 84);
      });

      test('should return null for non-SuccessState', () {
        const initialState = InitialState<int>();
        const loadingState = LoadingState<int>();
        final failureState = FailureState<int>();
        
        expect(initialState.mapSuccessData((value) => value * 2), isNull);
        expect(loadingState.mapSuccessData((value) => value * 2), isNull);
        expect(failureState.mapSuccessData((value) => value * 2), isNull);
      });
    });
  });
} 