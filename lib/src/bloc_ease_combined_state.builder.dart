import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BlocEaseCombinedStateBuilder extends StatefulWidget {
  BlocEaseCombinedStateBuilder({
    super.key,
    required this.blocEaseCubits,
    required this.successBuilder,
    this.errorBuilder,
  }) : assert(blocEaseCubits.isEmpty == false, 'blocEaseCubits should not be empty');

  final List<Cubit<BlocEaseState>> blocEaseCubits;
  final Widget Function(List<SucceedState> states) successBuilder;
  final Widget Function(List<FailedState>? states)? errorBuilder;

  @override
  State<BlocEaseCombinedStateBuilder> createState() => _BlocEaseCombinedStateBuilderState();
}

class _BlocEaseCombinedStateBuilderState extends State<BlocEaseCombinedStateBuilder>
    with AutomaticKeepAliveClientMixin {
  late final _stream = MergeStream(widget.blocEaseCubits.map((e) => e.stream));

  Widget failureWidget(List<FailedState>? failedStates) => widget.errorBuilder != null
      ? widget.errorBuilder!(failedStates)
      : context.failedStateWidget(
          failedStates?.first.failureMessage,
          failedStates?.first.exceptionObject,
          failedStates?.first.retryCallback,
        );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return failureWidget(null);

          final states = widget.blocEaseCubits.map((e) => e.state).toList();

          final failedStates = states.whereType<FailedState>().toList();
          if (failedStates.isNotEmpty) return failureWidget(failedStates);

          final areAnyInitialState = states.any((state) => state is InitialState);
          if (areAnyInitialState) return context.initialStateWidget();

          final areAnyLoadingState = states.any((state) => state is LoadingState);
          if (areAnyLoadingState) return context.loadingStateWidget();

          final successStates = states.whereType<SucceedState>().toList();
          return widget.successBuilder(successStates);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
