import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:bloc_ease/four_state.bloc.dart';

import '../../repository.dart';
import '../models/item.dart';

typedef ComplexListState = FourStates<List<Item>>;

class ComplexListCubit extends FourStateBloc<List<Item>> {
  ComplexListCubit({required this.repository})
      : super(const ComplexListState.loading());

  final Repository repository;

  Future<void> fetchList() async {
    try {
      // emit(const ComplexListState.loading());
      final items = await repository.fetchItems();
      emit(ComplexListState.succeed(items));
    } on Exception {
      emit(const ComplexListState.failed());
    }
  }

  Future<void> deleteItem(String id) async {
    state.maybeWhen(
      orElse: () => null,
      succeed: (items) {
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
      },
    );
  }
}
