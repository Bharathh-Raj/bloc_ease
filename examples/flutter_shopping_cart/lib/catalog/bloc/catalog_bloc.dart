import 'package:bloc_ease/bloc_ease.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';

import '../../shopping_repository.dart';

part 'catalog_event.dart';

typedef CatalogState = BlocEaseState<Catalog>;

typedef CatalogInitialState = InitialState<Catalog>;
typedef CatalogLoadingState = LoadingState<Catalog>;
typedef CatalogSuccessState = SuccessState<Catalog>;
typedef CatalogFailureState = FailureState<Catalog>;

typedef CatalogBlocBuilder = BlocBuilder<CatalogBloc, CatalogState>;
typedef CatalogBlocListener = BlocListener<CatalogBloc, CatalogState>;
typedef CatalogBlocConsumer = BlocConsumer<CatalogBloc, CatalogState>;

typedef CatalogBlocEaseBuilder = BlocEaseStateBuilder<CatalogBloc, Catalog>;
typedef CatalogBlocEaseListener = BlocEaseStateListener<CatalogBloc, Catalog>;
typedef CatalogBlocEaseConsumer = BlocEaseStateConsumer<CatalogBloc, Catalog>;

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
      emit(CatalogSuccessState(Catalog(itemNames: catalog)));
    } catch (_) {
      emit(CatalogFailureState());
    }
  }
}
