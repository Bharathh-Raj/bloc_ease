import 'package:bloc_ease/bloc_ease.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';

import '../../shopping_repository.dart';

part 'catalog_event.dart';

typedef CatalogState = FourStates<Catalog>;

typedef CatalogInitialState = InitialState<Catalog>;
typedef CatalogLoadingState = LoadingState<Catalog>;
typedef CatalogSucceedState = SucceedState<Catalog>;
typedef CatalogFailedState = FailedState<Catalog>;

typedef CatalogBuilder = FourStateBuilder<CatalogBloc, Catalog>;

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required this.shoppingRepository})
      : super(CatalogLoadingState()) {
    on<CatalogStarted>(_onStarted);
  }

  final ShoppingRepository shoppingRepository;

  Future<void> _onStarted(
    CatalogStarted event,
    Emitter<CatalogState> emit,
  ) async {
    emit(CatalogLoadingState());
    try {
      final catalog = await shoppingRepository.loadCatalog();
      emit(CatalogSucceedState(Catalog(itemNames: catalog)));
    } catch (_) {
      emit(CatalogFailedState());
    }
  }
}
