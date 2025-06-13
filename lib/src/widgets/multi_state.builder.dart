import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// A widget that listens to multiple Bloc states and builds accordingly.
///
/// This widget is useful when you need to wait for more than one cubit to build a widget,
/// show a common loading indicator while multiple cubits are loading, or show a common error widget if any cubit fails.
///
/// - [successBuilder] is called when all the states are [SuccessState].
/// - [failureBuilder] is called when any state is [FailureState].
/// - [loadingBuilder] is called when any state is [LoadingState].
class BlocEaseMultiStateBuilder extends StatefulWidget {
  /// Creates a `BlocEaseMultiStateBuilder` widget.
  ///
  /// The [blocEaseBlocs] parameter is required and should not be empty.
  /// The [successBuilder] is a required callback that is invoked when all the states are [SuccessState].
  /// The [loadingBuilder] and [failureBuilder] are optional callbacks, If not provided, the corresponding widgets configured in [BlocEaseStateWidgetProvider] will be used.
  BlocEaseMultiStateBuilder({
    super.key,
    required this.blocEaseBlocs,
    required this.successBuilder,
    this.loadingBuilder,
    this.failureBuilder,
  }) : assert(blocEaseBlocs.isNotEmpty, 'blocEaseBlocs should not be empty');

  /// List of Blocs/Cubits that should emits [BlocEaseState].
  final List<StateStreamable<BlocEaseState>> blocEaseBlocs;

  /// Called when none of the states are [LoadingState], [FailureState], or [InitialState].
  final Widget Function(List<SuccessState> states) successBuilder;

  /// Called when any of the states are in [LoadingState] and none are in [InitialState] or [FailureState].
  /// Provides all the [LoadingState]s of blocs that are currently loading.
  /// Useful for calculating loading progress based on the count of [LoadingState].
  /// If not provided, the loading widget from [BlocEaseStateWidgetProvider] is used with progress based on [LoadingState] count.
  final Widget Function(List<LoadingState> states)? loadingBuilder;

  /// Called when any of the states are [FailureState].
  /// If not provided, the failure state widget from [BlocEaseStateWidgetProvider] is used with the first failed state parameters.
  final Widget Function(List<FailureState>? states)? failureBuilder;

  @override
  State<BlocEaseMultiStateBuilder> createState() =>
      _BlocEaseMultiStateBuilderState();
}

class _BlocEaseMultiStateBuilderState extends State<BlocEaseMultiStateBuilder>
    with AutomaticKeepAliveClientMixin {
  late final _stream = MergeStream(widget.blocEaseBlocs.map((e) => e.stream));

  Widget failureWidget(List<FailureState>? failureStates) =>
      widget.failureBuilder != null
          ? widget.failureBuilder!(failureStates)
          : context.failureStateWidget(failureStates!.first);

  Widget loadingWidget(List<LoadingState> loadingStates) =>
      widget.loadingBuilder != null
          ? widget.loadingBuilder!(loadingStates)
          : context.loadingStateWidget(loadingStates.last);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return failureWidget(null);

          final states = widget.blocEaseBlocs.map((e) => e.state).toList();

          final failureStates = states.whereType<FailureState>().toList();
          if (failureStates.isNotEmpty) return failureWidget(failureStates);

          final initialStates = states.whereType<InitialState>().toList();
          if (initialStates.isNotEmpty) {
            return context.initialStateWidget(initialStates.first);
          }

          final loadingStates = states.whereType<LoadingState>().toList();
          if (loadingStates.isNotEmpty) return loadingWidget(loadingStates);

          final successStates = states.whereType<SuccessState>().toList();
          return widget.successBuilder(successStates);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
