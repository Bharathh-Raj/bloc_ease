import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'complex_list/complex_list.dart';
import 'repository.dart';

class App extends MaterialApp {
  App({required Repository repository, super.key})
      : super(
          home: RepositoryProvider.value(
            value: repository,
            child: const ComplexListPage(),
          ),
        );
}
