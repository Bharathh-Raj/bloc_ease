import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository.dart';
import '../models/item.dart';

typedef ComplexListState = FourStates<List<Item>>;

typedef ComplexListInitialState = InitialState<List<Item>>;
typedef ComplexListLoadingState = LoadingState<List<Item>>;
typedef ComplexListSucceedState = SucceedState<List<Item>>;
typedef ComplexListFailedState = FailedState<List<Item>>;

class ComplexListCubit extends Cubit<ComplexListState> {
  ComplexListCubit({required this.repository})
      : super(ComplexListState.loading());

  final Repository repository;

  Future<void> fetchList() async {
    try {
      final items = await repository.fetchItems();
      emit(ComplexListState.succeed(items));
    } on Exception {
      emit(ComplexListState.failed());
    }
  }

  Future<void> deleteItem(String id) async {
    final state = this.state;
    if (state is ComplexListSucceedState) {
      final items = state.successObject;
      final deleteInProgress = List.of(items).map((item) {
        return item.id == id ? item.copyWith(isDeleting: true) : item;
      }).toList();

      emit(ComplexListState.succeed(deleteInProgress));

      unawaited(
        repository.deleteItem(id).then((_) {
          final deleteSuccess = List.of(items)
            ..removeWhere((element) => element.id == id);
          emit(ComplexListState.succeed(deleteSuccess));
        }),
      );
    }
  }
}
