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

typedef ComplexListBlocBuilder
    = BlocBuilder<ComplexListCubit, ComplexListState>;
typedef ComplexListBlocListener
    = BlocListener<ComplexListCubit, ComplexListState>;
typedef ComplexListBlocConsumer
    = BlocConsumer<ComplexListCubit, ComplexListState>;

typedef ComplexListBlocEaseBuilder
    = FourStateBuilder<ComplexListCubit, List<Item>>;
typedef ComplexListBlocEaseListener
    = FourStateListener<ComplexListCubit, List<Item>>;
typedef ComplexListBlocEaseConsumer
    = FourStateConsumer<ComplexListCubit, List<Item>>;

class ComplexListCubit extends Cubit<ComplexListState> {
  ComplexListCubit({required this.repository})
      : super(const ComplexListLoadingState());

  final Repository repository;

  Future<void> fetchList() async {
    try {
      final items = await repository.fetchItems();
      emit(ComplexListSucceedState(items));
    } on Exception {
      emit(ComplexListFailedState());
    }
  }

  Future<void> deleteItem(String id) async {
    final state = this.state;
    if (state is ComplexListSucceedState) {
      final items = state.successObject;
      final deleteInProgress = List.of(items).map((item) {
        return item.id == id ? item.copyWith(isDeleting: true) : item;
      }).toList();

      emit(ComplexListSucceedState(deleteInProgress));

      unawaited(
        repository.deleteItem(id).then((_) {
          final deleteSuccess = List.of(items)
            ..removeWhere((element) => element.id == id);
          emit(ComplexListSucceedState(deleteSuccess));
        }),
      );
    }
  }
}
