import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc_ease.dart';

/// Mixin that provides debouncing functionality for state emissions.
///
/// Use this mixin when you want to delay state emissions by a specified duration.
/// This is useful for scenarios like search functionality where you want to wait
/// for the user to stop typing before making an API call.
///
/// Example usage with Cubit:
/// ```dart
/// class SearchCubit extends Cubit<BlocEaseState<List<String>>> with StateDebounce {
///   void search(String query) {
///     debounce(() async {
///       emitLoading();
///       try {
///         final results = await searchApi.search(query);
///         emitSuccess(results);
///       } catch (e) {
///         emitFailure(e.toString());
///       }
///     });
///   }
/// }
/// ```
///
/// Example usage with Bloc:
/// ```dart
/// class SearchBloc extends Bloc<SearchEvent, BlocEaseState<List<String>>> with StateDebounce {
///   SearchBloc() : super(const InitialState()) {
///     on<SearchQueryChanged>((event, emit) {
///       debounce(() async {
///         emit(const LoadingState());
///         try {
///           final results = await searchApi.search(event.query);
///           emit(SuccessState(results));
///         } catch (e) {
///           emit(FailureState(e.toString()));
///         }
///       });
///     });
///   }
/// }
/// Use transformer in bloc for more control
/// ```
mixin StateDebounce<T> on BlocBase<BlocEaseState<T>> {
  Timer? _debounceTimer;

  /// Debounces state emission with given duration
  void debounce(void Function() callback, [Duration duration = const Duration(milliseconds: 300)]) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      if (!isClosed) {
        callback();
      }
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
