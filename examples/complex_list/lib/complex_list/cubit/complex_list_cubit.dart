import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:bloc_ease/four_state.bloc.dart';

import '../../repository.dart';
import '../models/item.dart';

class ComplexListCubit extends FourStateBloc<List<Item>> {
  ComplexListCubit({required this.repository});

  final Repository repository;

  Future<void> fetchList() async {
    try {
      emit(const FourStates.loading());
      final items = await repository.fetchItems();
      emit(FourStates.succeed(items));
    } on Exception {
      emit(const FourStates.failed());
    }
  }

  Future<void> deleteItem(String id) async {
    state.maybeWhen(
      orElse: () => null,
      succeed: (items) {
        final deleteInProgress = List.of(items).map((item) {
          return item.id == id ? item.copyWith(isDeleting: true) : item;
        }).toList();

        emit(FourStates.succeed(deleteInProgress));

        unawaited(
          repository.deleteItem(id).then((_) {
            final deleteSuccess = List.of(items)
              ..removeWhere((element) => element.id == id);
            emit(FourStates.succeed(deleteSuccess));
          }),
        );
      },
    );
  }
}
