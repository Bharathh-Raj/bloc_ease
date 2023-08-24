import 'package:bloc_ease/bloc_ease.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../catalog/models/item.dart';
import '../../shopping_repository.dart';
import '../models/cart.dart';

part 'cart_event.dart';

typedef CartState = FourStates<Cart>;

typedef CartInitialState = InitialState<Cart>;
typedef CartLoadingState = LoadingState<Cart>;
typedef CartSucceedState = SucceedState<Cart>;
typedef CartFailedState = FailedState<Cart>;

typedef CartBuilder = FourStateBuilder<CartBloc, Cart>;

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.shoppingRepository}) : super(CartState.loading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }

  final ShoppingRepository shoppingRepository;

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartState.loading());
    try {
      final items = await shoppingRepository.loadCartItems();
      emit(CartState.succeed(Cart(items: [...items])));
    } catch (_) {
      emit(CartState.failed());
    }
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    final state = this.state;
    if (state is CartSucceedState) {
      final cart = state.successObject;
      try {
        shoppingRepository.addItemToCart(event.item);
        emit(CartState.succeed(Cart(items: [...cart.items, event.item])));
      } catch (_) {
        emit(CartState.failed());
      }
    }
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartSucceedState) {
      final cart = state.successObject;

      try {
        shoppingRepository.removeItemFromCart(event.item);
        emit(
          CartState.succeed(
            Cart(
              items: [...cart.items]..remove(event.item),
            ),
          ),
        );
      } catch (_) {
        emit(CartState.failed());
      }
    }
  }
}
