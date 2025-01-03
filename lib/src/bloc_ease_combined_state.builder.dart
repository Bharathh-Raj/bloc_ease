import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Sometimes we need to wait for more than one cubit to build a widget or show only one common loading indicator
/// while multiple cubits are loading or show only one error widget if any cubit fails.
///
/// [successBuilder] gets called when all the states are [SucceedState].
/// [errorBuilder] gets called when any state is [FailedState].
/// [loadingBuilder] gets called when any state is [LoadingState].
class BlocEaseMultiStateBuilder extends StatefulWidget {
  BlocEaseMultiStateBuilder({
    super.key,
    required this.blocEaseBlocs,
    required this.successBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : assert(blocEaseBlocs.isEmpty == false, 'blocEaseCubits should not be empty');

  /// Blocs/Cubits that should emit [BlocEaseState]
  final List<Cubit<BlocEaseState>> blocEaseBlocs;

  /// Called when none of the state is [LoadingState] or [FailedState] or [InitialState]
  final Widget Function(List<SucceedState> states) successBuilder;

  /// Called when any of the state is still in [LoadingState] and not any state is [InitialState] or [FailedState].
  /// Have all the [LoadingState]s of blocs that are currently loading. Useful for calculating loading progress based on the count of [LoadingState].
  /// If not passed, global loading widget from [BlocEaseStateWidgetsProvider] gets called with progress field based on [LoadingState] count.
  final Widget Function(List<LoadingState> states)? loadingBuilder;

  /// Called when any of the state is [FailedState].
  /// If not passed, global failure state widget from [BlocEaseStateWidgetsProvider] gets called with first failed state params.
  final Widget Function(List<FailedState>? states)? errorBuilder;

  @override
  State<BlocEaseMultiStateBuilder> createState() => _BlocEaseMultiStateBuilderState();
}

class _BlocEaseMultiStateBuilderState extends State<BlocEaseMultiStateBuilder>
    with AutomaticKeepAliveClientMixin {
  late final _stream = MergeStream(widget.blocEaseBlocs.map((e) => e.stream));

  Widget failureWidget(List<FailedState>? failedStates) => widget.errorBuilder != null
      ? widget.errorBuilder!(failedStates)
      : context.failedStateWidget(failedStates?.first.message, failedStates?.first.exception,
          failedStates?.first.retryCallback);

  Widget loadingWidget(List<LoadingState> loadingStates) => widget.loadingBuilder != null
      ? widget.loadingBuilder!(loadingStates)
      : context.loadingStateWidget(
          loadingStates.first.message,
          loadingStates
                  .map<double>((e) => e.progress ?? 0.0)
                  .fold<double>(0.0, (progress, e) => progress + e) /
              loadingStates.length);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return failureWidget(null);

          final states = widget.blocEaseBlocs.map((e) => e.state).toList();

          final failedStates = states.whereType<FailedState>().toList();
          if (failedStates.isNotEmpty) return failureWidget(failedStates);

          final areAnyInitialState = states.any((state) => state is InitialState);
          if (areAnyInitialState) return context.initialStateWidget();

          final loadingStates = states.whereType<LoadingState>().toList();
          if (loadingStates.isNotEmpty) return loadingWidget(loadingStates);

          final successStates = states.whereType<SucceedState>().toList();
          return widget.successBuilder(successStates);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
