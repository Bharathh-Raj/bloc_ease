import 'package:flutter/material.dart';
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BlocEase Package Example
/// -----------------------
/// 
/// This example demonstrates how to use the bloc_ease package to simplify state management in Flutter.
/// 
/// 1. BLOC EASE STATES
/// -------------------
/// The package provides four main state types:
/// - InitialState: The default starting state
/// - LoadingState: Represents loading operations with optional message and progress
/// - SuccessState: Contains the successfully loaded data
/// - FailureState: Represents errors with optional message, exception, and retry callback
/// 
/// 2. CUBITS/BLOCS WITH BLOC EASE
/// ------------------------------
/// This example demonstrates three different types of Cubits:
/// - Basic Cubit (UserCubit): Uses basic BlocEaseState with emitLoading, emitSuccess, emitFailure methods
/// - Cubit with CacheExBlocEaseStateMixin (ProductCubit): Caches previous states for comparison and optimization
/// - Cubit with StateDebounce mixin (SearchCubit): Debounces state emissions to handle rapid changes
/// 
/// 3. BLOC EASE STATE WIDGET PROVIDER
/// ---------------------------------
/// BlocEaseStateWidgetProvider is used at the app root to define default widgets for:
/// - initialStateBuilder: Widget to show when state is InitialState
/// - loadingStateBuilder: Widget to show when state is LoadingState (with progress and message)
/// - failureStateBuilder: Widget to show when state is FailureState (with error and retry)
/// 
/// These default widgets are used automatically by BlocEaseStateBuilder when specific builders aren't provided.
/// 
/// 4. BLOC EASE WIDGETS
/// -------------------
/// The example uses BlocEaseStateBuilder which handles different states and renders appropriate UI:
/// - Automatically renders the default widget from BlocEaseStateWidgetProvider for loading/error states
/// - Only requires implementation of successBuilder for the success case
/// - Can override default widgets with custom implementations for specific cases

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocEaseStateWidgetProvider is used at the app root to define default widgets
    // for InitialState, LoadingState, and FailureState
    return BlocEaseStateWidgetProvider(
      initialStateBuilder: (_) => const Center(child: Text('Initial')),
      loadingStateBuilder: (state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: state.progress),
            if (state.message != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(state.message!),
              ),
          ],
        ),
      ),
      failureStateBuilder: (state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message ?? 'Error'),
            if (state.retryCallback != null)
              ElevatedButton(
                onPressed: state.retryCallback,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlocEase Examples')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => UserCubit(UserRepository())..fetchUser(),
                      child: const UserScreen(),
                    ),
                  ),
                );
              },
              child: const Text('User Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ProductCubit(ProductRepository())..fetchProducts(),
                      child: const ProductsScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Products Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SearchCubit(),
                      child: const SearchScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Search Example'),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Basic Cubit using BlocEaseState
// This demonstrates the simplest way to use BlocEaseState with a Cubit
// It uses the emitLoading, emitSuccess, and emitFailure extension methods
typedef UserState = BlocEaseState<User>;

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(const UserInitialState());

  final UserRepository _userRepository;

  Future<void> fetchUser() async {
    // Emit LoadingState with a descriptive message
    emitLoading('Loading user profile...');

    try {
      final user = await _userRepository.fetchUser();
      // Emit SuccessState with the fetched data
      emitSuccess(user);
    } catch (e) {
      // Emit FailureState with error message, exception, and retry callback
      emitFailure('Failed to load user', e, () => fetchUser());
    }
  }
}

typedef UserInitialState = InitialState<User>;
typedef UserLoadingState = LoadingState<User>;
typedef UserSuccessState = SuccessState<User>;
typedef UserFailureState = FailureState<User>;

typedef UserBlocBuilder = BlocBuilder<UserCubit, UserState>;
typedef UserBlocListener = BlocListener<UserCubit, UserState>;
typedef UserBlocConsumer = BlocConsumer<UserCubit, UserState>;

typedef UserBlocEaseBuilder = BlocEaseStateBuilder<UserCubit, User>;
typedef UserBlocEaseListener = BlocEaseStateListener<UserCubit, User>;
typedef UserBlocEaseConsumer = BlocEaseStateConsumer<UserCubit, User>;

// 2. Cubit with CacheExBlocEaseStateMixin
// This demonstrates using the CacheExBlocEaseStateMixin to access previous states
// Can access exInitialState, exLoadingState, exSuccessState, exFailureState
typedef ProductState = BlocEaseState<List<Product>>;

class ProductCubit extends Cubit<ProductState> with CacheExBlocEaseStateMixin {
  ProductCubit(this._productRepository) : super(const ProductInitialState());

  final ProductRepository _productRepository;

  Future<void> fetchProducts({bool refresh = false}) async {
    // Access cached success state to show loading with previous data
    if (!refresh && exSuccessState != null) {
      // Use previous success state to create a better UX during reload
      emitLoading('Refreshing products...', 0.3);
    } else {
      emitLoading('Loading products...', 0.1);
    }

    try {
      // Demonstrate progress updates for LoadingState
      await Future.delayed(const Duration(milliseconds: 500));
      emitLoading('Fetching products...', 0.5);

      await Future.delayed(const Duration(milliseconds: 500));
      emitLoading('Processing data...', 0.8);

      final products = await _productRepository.fetchProducts();
      emitSuccess(products);
    } catch (e) {
      emitFailure('Failed to load products', e, () => fetchProducts());
    }
  }
}

typedef ProductInitialState = InitialState<List<Product>>;
typedef ProductLoadingState = LoadingState<List<Product>>;
typedef ProductSuccessState = SuccessState<List<Product>>;
typedef ProductFailureState = FailureState<List<Product>>;

typedef ProductBlocBuilder = BlocBuilder<ProductCubit, ProductState>;
typedef ProductBlocListener = BlocListener<ProductCubit, ProductState>;
typedef ProductBlocConsumer = BlocConsumer<ProductCubit, ProductState>;

typedef ProductBlocEaseBuilder = BlocEaseStateBuilder<ProductCubit, List<Product>>;
typedef ProductBlocEaseListener = BlocEaseStateListener<ProductCubit, List<Product>>;
typedef ProductBlocEaseConsumer = BlocEaseStateConsumer<ProductCubit, List<Product>>;

// 3. Example using StateDebounce mixin
// This demonstrates using the StateDebounce mixin to prevent rapid state emissions
// Useful for search inputs, form validation, etc.
typedef SearchState = BlocEaseState<List<String>>;

class SearchCubit extends Cubit<SearchState> with StateDebounce {
  SearchCubit() : super(const SearchInitialState());

  void search(String query) {
    if (query.isEmpty) {
      // Reset to initial state when query is empty
      emitInitial();
      return;
    }
    emitLoading('Searching...');

    // Debounce the search operation to prevent rapid emissions
    // This will wait 300ms (default) after the last call before executing
    debounce(() async {
      try {
        // Simulate search API call
        await Future.delayed(const Duration(seconds: 1));
        final results = ['$query result 1', '$query result 2', '$query result 3'];
        emitSuccess(results);
      } catch (e) {
        emitFailure('Search failed', e);
      }
    });
  }
}

typedef SearchInitialState = InitialState<List<String>>;
typedef SearchLoadingState = LoadingState<List<String>>;
typedef SearchSuccessState = SuccessState<List<String>>;
typedef SearchFailureState = FailureState<List<String>>;

typedef SearchBlocBuilder = BlocBuilder<SearchCubit, SearchState>;
typedef SearchBlocListener = BlocListener<SearchCubit, SearchState>;
typedef SearchBlocConsumer = BlocConsumer<SearchCubit, SearchState>;

typedef SearchBlocEaseBuilder = BlocEaseStateBuilder<SearchCubit, List<String>>;
typedef SearchBlocEaseListener = BlocEaseStateListener<SearchCubit, List<String>>;
typedef SearchBlocEaseConsumer = BlocEaseStateConsumer<SearchCubit, List<String>>;

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // UserBlocEaseBuilder handles all state types automatically
        // Only the successBuilder is required, others use defaults from BlocEaseStateWidgetProvider
      appBar: AppBar(title: const Text('User')),
      body: UserBlocEaseBuilder(
        successBuilder: (user) => Center(child: Text(user.name)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<UserCubit>().fetchUser,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ProductBlocEaseBuilder automatically handles loading/error states
      // using the default widgets provided by BlocEaseStateWidgetProvider
      appBar: AppBar(title: const Text('Products')),
      body: ProductBlocEaseBuilder(
        successBuilder: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) => ListTile(title: Text(products[i].name)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ProductCubit>().fetchProducts(refresh: true),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: context.read<SearchCubit>().search,
              decoration: const InputDecoration(hintText: 'Search...'),
            ),
            Expanded(
              // Here we override the initialBuilder while still using default
              // loading and failure widgets from BlocEaseStateWidgetProvider
              child: SearchBlocEaseBuilder(
                successBuilder: (results) => ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, i) => ListTile(title: Text(results[i])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  const User({required this.name});
}

class Product {
  final String name;
  const Product({required this.name});
}

class UserRepository {
  Future<User> fetchUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    return const User(name: 'John Doe');
  }
}

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    return [
      const Product(name: 'Product 1'),
      const Product(name: 'Product 2'),
      const Product(name: 'Product 3'),
    ];
  }
}
