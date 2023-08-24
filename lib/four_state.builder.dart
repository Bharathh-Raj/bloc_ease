import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'callbacks.dart';

class FourStateBuilder<B extends BlocBase<FourStates<T>>, T>
    extends BlocBuilder<B, FourStates<T>> {
  FourStateBuilder({
    required SucceedBuilder<T> succeedBuilder,
    InitialBuilder? initialBuilder,
    LoadingBuilder? loadingBuilder,
    FailureBuilder? failureBuilder,
    B? bloc,
    BlocBuilderCondition<FourStates<T>>? buildWhen,
    super.key,
  }) : super(
          bloc: bloc,
          buildWhen: buildWhen,
          builder: (context, state) => state.when(
            initial: initialBuilder ??
                StateWidgetsProvider.of(context).initialStateBuilder,
            loading: loadingBuilder ??
                StateWidgetsProvider.of(context).loadingStateBuilder,
            failed: failureBuilder ??
                StateWidgetsProvider.of(context).failureStateBuilder,
            succeed: succeedBuilder,
          ),
        );
}
