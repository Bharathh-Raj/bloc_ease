import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'repository.dart';
import 'simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(BlocEaseStateWidgetsProvider(
      initialStateBuilder: () => const Placeholder(),
      loadingStateBuilder: ([progress]) => const Center(child: CircularProgressIndicator()),
      failureStateBuilder: ([failureMessage, exception, retryCallback]) =>
          Center(child: Text(failureMessage ?? 'Oops something went wrong!')),
      child: App(repository: Repository())));
}
