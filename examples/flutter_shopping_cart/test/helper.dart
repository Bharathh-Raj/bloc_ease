import 'package:bloc_ease/bloc_ease.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/cart/cart.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockCatalogBloc extends MockBloc<CatalogEvent, CatalogState> implements CatalogBloc {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp({
    required Widget child,
    CartBloc? cartBloc,
    CatalogBloc? catalogBloc,
  }) {
    return pumpWidget(
      BlocEaseStateWidgetsProvider(
        initialStateBuilder: () => const SizedBox(),
        loadingStateBuilder: ([message, progress]) => const Center(child: CircularProgressIndicator()),
        failureStateBuilder: ([failureMessage, exception, retryCallback]) => Center(
          child: Text(failureMessage ?? 'Something went wrong!'),
        ),
        child: MaterialApp(
          home: MultiBlocProvider(
            providers: [
              if (cartBloc != null)
                BlocProvider.value(value: cartBloc)
              else
                BlocProvider(create: (_) => MockCartBloc()),
              if (catalogBloc != null)
                BlocProvider.value(value: catalogBloc)
              else
                BlocProvider(create: (_) => MockCatalogBloc()),
            ],
            child: child,
          ),
        ),
      ),
    );
  }
}
