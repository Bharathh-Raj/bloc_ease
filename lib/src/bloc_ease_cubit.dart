import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_ease_states.dart';

class BlocEaseCubit<T> extends Cubit<BlocEaseState<T>> {
  BlocEaseCubit(super.initialState);
}
