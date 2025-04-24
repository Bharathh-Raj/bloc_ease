import 'package:flutter/material.dart';
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * BlocEase Package Example
 * -----------------------
 * 
 * This example demonstrates how to use the bloc_ease package to simplify state management in Flutter.
 * 
 * 1. BLOC EASE STATES
 * -------------------
 * The package provides four main state types:
 * - InitialState: The default starting state
 * - LoadingState: Represents loading operations with optional message and progress
 * - SuccessState: Contains the successfully loaded data
 * - FailureState: Represents errors with optional message, exception, and retry callback
 * 
 * 2. CUBITS/BLOCS WITH BLOC EASE
 * ------------------------------
 * This example demonstrates three different types of Cubits:
 * - Basic Cubit (UserCubit): Uses basic BlocEaseState with emitLoading, emitSuccess, emitFailure methods
 * - Cubit with CacheExBlocEaseStateMixin (ProductCubit): Caches previous states for comparison and optimization
 * - Cubit with StateDebounce mixin (SearchCubit): Debounces state emissions to handle rapid changes
 * 
 * 3. BLOC EASE STATE WIDGET PROVIDER
 * ---------------------------------
 * BlocEaseStateWidgetProvider is used at the app root to define default widgets for:
 * - initialStateBuilder: Widget to show when state is InitialState
 * - loadingStateBuilder: Widget to show when state is LoadingState (with progress and message)
 * - failureStateBuilder: Widget to show when state is FailureState (with error and retry)
 * 
 * These default widgets are used automatically by BlocEaseStateBuilder when specific builders aren't provided.
 * 
 * 4. BLOC EASE WIDGETS
 * -------------------
 * The example uses BlocEaseStateBuilder which handles different states and renders appropriate UI:
 * - Automatically renders the default widget from BlocEaseStateWidgetProvider for loading/error states
 * - Only requires implementation of succeedBuilder for the success case
 * - Can override default widgets with custom implementations for specific cases
 */

// Example data models
class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

class Product {
  final String id;
  final String name;
  final double price;

  const Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
}

// Example repositories
class UserRepository {
  Future<User> fetchUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    return const User(id: '1', name: 'John Doe', email: 'john@example.com');
  }
}

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));
    return [
      const Product(id: '1', name: 'iPhone', price: 999.99),
      const Product(id: '2', name: 'MacBook', price: 1299.99),
      const Product(id: '3', name: 'AirPods', price: 199.99),
    ];
  }
}

// 1. Basic Cubit using BlocEaseState
// This demonstrates the simplest way to use BlocEaseState with a Cubit
// It uses the emitLoading, emitSuccess, and emitFailure extension methods
class UserCubit extends Cubit<BlocEaseState<User>> {
  final UserRepository _userRepository;

  UserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const InitialState()); // Start with InitialState

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

// 2. Cubit with CacheExBlocEaseStateMixin
// This demonstrates using the CacheExBlocEaseStateMixin to access previous states
// Can access exInitialState, exLoadingState, exSuccessState, exFailureState
class ProductCubit extends Cubit<BlocEaseState<List<Product>>> with CacheExBlocEaseStateMixin {
  final ProductRepository _productRepository;

  ProductCubit({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const InitialState());

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

// 3. Example using StateDebounce mixin
// This demonstrates using the StateDebounce mixin to prevent rapid state emissions
// Useful for search inputs, form validation, etc.
class SearchCubit extends Cubit<BlocEaseState<List<String>>> with StateDebounce {
  SearchCubit() : super(const InitialState());

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
        final results = [
          '$query result 1',
          '$query result 2',
          '$query result 3',
        ];
        emitSuccess(results);
      } catch (e) {
        emitFailure('Search failed', e);
      }
    });
  }
}

// Screens
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // BlocEaseStateBuilder handles all state types automatically
        // Only the succeedBuilder is required, others use defaults from BlocEaseStateWidgetProvider
        child: BlocEaseStateBuilder<UserCubit, User>(
          succeedBuilder: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('User Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('ID: ${user.id}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserCubit>().fetchUser(),
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
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.green,
      ),
      // BlocEaseStateBuilder automatically handles loading/error states
      // using the default widgets provided by BlocEaseStateWidgetProvider
      body: BlocEaseStateBuilder<ProductCubit, List<Product>>(
        succeedBuilder: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              leading: const Icon(Icons.shopping_cart),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ProductCubit>().fetchProducts(refresh: true),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<SearchCubit>().search(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              // Here we override the initialBuilder while still using default
              // loading and failure widgets from BlocEaseStateWidgetProvider
              child: BlocEaseStateBuilder<SearchCubit, List<String>>(
                initialBuilder: () => const Center(
                  child: Text('Enter a search term'),
                ),
                succeedBuilder: (results) {
                  if (results.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(results[index]),
                        leading: const Icon(Icons.article),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocEaseStateWidgetProvider is used at the app root to define default widgets
    // for InitialState, LoadingState, and FailureState
    return BlocEaseStateWidgetProvider(
      // Define default widget for InitialState
      initialStateBuilder: (_) => const Center(
        child: Text('Ready to start', style: TextStyle(fontSize: 18)),
      ),
      // Define default widget for LoadingState with progress and message support
      loadingStateBuilder: (loadingState) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: loadingState.progress,
            ),
            const SizedBox(height: 16),
            Text(loadingState.message ?? 'Loading...', 
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      // Define default widget for FailureState with error message and retry button
      failureStateBuilder: (failureState) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              failureState.message ?? 'An error occurred',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (failureState.retryCallback != null)
              ElevatedButton(
                onPressed: failureState.retryCallback,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
      child: MaterialApp(
        title: 'BlocEase Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
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
      appBar: AppBar(
        title: const Text('BlocEase Examples'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => UserCubit(
                        userRepository: UserRepository(),
                      )..fetchUser(),
                      child: const UserScreen(),
                    ),
                  ),
                );
              },
              child: const Text('User Profile Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ProductCubit(
                        productRepository: ProductRepository(),
                      )..fetchProducts(),
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

void main() {
  runApp(const ExampleApp());
}

