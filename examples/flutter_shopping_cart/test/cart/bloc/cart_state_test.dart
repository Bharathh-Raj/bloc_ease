// ignore_for_file: prefer_const_constructors
import 'package:flutter_shopping_cart/cart/cart.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCart extends Fake implements Cart {}

void main() {
  group('CartState', () {
    group('CartLoading', () {
      test('supports value comparison', () {
        expect(CartLoadingState(), CartLoadingState());
      });
    });

    group('CartLoaded', () {
      final cart = FakeCart();
      test('supports value comparison', () {
        expect(CartSuccessState(cart), CartSuccessState(cart));
      });
    });

    group('CartError', () {
      test('supports value comparison', () {
        expect(CartFailureState(), CartFailureState());
      });
    });
  });
}
