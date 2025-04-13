import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'repository.dart';
import 'simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(BlocEaseStateWidgetProvider(
      initialStateBuilder: (_) => const Placeholder(),
      loadingStateBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
      failureStateBuilder: (failureState) =>
          Center(child: Text(failureState.message ?? 'Oops something went wrong!')),
      child: App(repository: Repository())));
}
