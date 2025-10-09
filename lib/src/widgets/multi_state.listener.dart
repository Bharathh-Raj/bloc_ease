import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// A widget that listens to multiple Bloc states and triggers a callback when states change.
///
/// This widget is useful when you need to perform an operation based on the combined states of multiple cubits.
///
/// - [blocEaseBlocs] is a list of cubits that emit [BlocEaseState].
/// - [onStateChange] is a callback that is invoked with the combined states.
/// - [child] is the widget below this widget in the tree.
///
/// PRO TIP: We can limit the type of [BlocEaseState] for all [blocEaseBlocs] by using Generics.
/// eg: By calling BlocEaseMultiStateListener<SuccessState>(blocEaseCubits: [...]), all the states we get via [onStateChange] will be [SuccessState]
class BlocEaseMultiStateListener<S extends BlocEaseState>
    extends StatefulWidget {
  const BlocEaseMultiStateListener({
    super.key,
    required this.blocEaseBlocs,
    required this.onStateChange,
    required this.child,
    this.shouldRunOnInit = false,
    this.canRunOnlyOnce = false,
  });

  /// Determines whether to run the listener during initialization. By default, `BlocListener` triggers the listener only on subsequent state changes.
  /// Setting this to true will trigger the listener immediately upon initialization.
  final bool shouldRunOnInit;

  /// Determines whether the listener can run only once. When set to true, the listener will trigger only on the first state change and then stop listening.
  final bool canRunOnlyOnce;

  /// List of cubits that emit [BlocEaseState].
  final List<StateStreamable<BlocEaseState>> blocEaseBlocs;

  /// Callback that is invoked with the combined states.
  final void Function(List<S> states) onStateChange;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<BlocEaseMultiStateListener<S>> createState() =>
      _BlocEaseMultiStateListenerState<S>();
}

class _BlocEaseMultiStateListenerState<S extends BlocEaseState> extends State<BlocEaseMultiStateListener<S>> {
  late final StreamSubscription<BlocEaseState> _stream;
  bool hasRun = false;

  @override
  void initState() {
    if (widget.shouldRunOnInit) {
      _onStateChange();
    }
    _stream = MergeStream(widget.blocEaseBlocs.map((e) => e.stream)).listen((event) => _onStateChange());
    super.initState();
  }

  void _onStateChange() {
    if (widget.canRunOnlyOnce && hasRun) return;
    final states = widget.blocEaseBlocs.map((e) => e.state).toList();
    final areAllStateAligningWithType = states.every((e) => e is S);
    if (areAllStateAligningWithType) {
      widget.onStateChange(states.map((e) => e as S).toList());
      hasRun = true;
    }
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
