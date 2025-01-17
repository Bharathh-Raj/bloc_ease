import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository.dart';
import '../models/item.dart';

class ComplexListCubit extends Cubit<ComplexListState>
    with CacheExBlocEaseStateMixin {
  ComplexListCubit({required this.repository})
      : super(const ComplexListLoadingState());

  final Repository repository;

  void fetchList() async {
    try {
      final items = await repository.fetchItems();
      emit(ComplexListSucceedState(items));
    } on Exception {
      emit(ComplexListFailedState());
    }
  }

  void deleteItem(String id) async {
    final state = this.state;
    if (state is ComplexListSucceedState) {
      final items = state.success;
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

typedef ComplexListState = BlocEaseState<List<Item>>;

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
    = BlocEaseStateBuilder<ComplexListCubit, List<Item>>;
typedef ComplexListBlocEaseListener
    = BlocEaseStateListener<ComplexListCubit, List<Item>>;
typedef ComplexListBlocEaseConsumer
    = BlocEaseStateConsumer<ComplexListCubit, List<Item>>;
