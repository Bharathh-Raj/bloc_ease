import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/cart/cart.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';
import 'package:flutter_shopping_cart/shopping_repository.dart';

class App extends StatelessWidget {
  const App({required this.shoppingRepository, super.key});

  final ShoppingRepository shoppingRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CatalogBloc(
            shoppingRepository: shoppingRepository,
          )..add(CatalogStarted()),
        ),
        BlocProvider(
          create: (_) => CartBloc(
            shoppingRepository: shoppingRepository,
          )..add(CartStarted()),
        )
      ],
      child: BlocEaseStateWidgetProvider(
        initialStateBuilder: () => const SizedBox(),
        loadingStateBuilder: ([message, progress]) => Center(
          child: CircularProgressIndicator(value: progress),
        ),
        failureStateBuilder: ([failureMessage, exception, retryCallback]) =>
            Center(
          child: Text(failureMessage ?? 'Something went wrong!'),
        ),
        child: MaterialApp(
          title: 'Flutter Bloc Shopping Cart',
          initialRoute: '/',
          routes: {
            '/': (_) => const CatalogPage(),
            '/cart': (_) => const CartPage(),
          },
        ),
      ),
    );
  }
}
