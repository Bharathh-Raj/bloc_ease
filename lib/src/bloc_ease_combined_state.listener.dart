import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Sometimes we need more than one cubit's state to do some operation.
/// This combines all the states from blocs/cubits passed on [blocEaseBlocs] and lets us access all via [onStateChange].
///
/// PRO TIP: We can limit the type of [BlocEaseState] for all [blocEaseBlocs] by using Generics.
/// eg: By calling BlocEaseMultiStateListener<SucceedState>(blocEaseCubits: [...]), all the states we get via [onStateChange] will be [SucceedState]
class BlocEaseMultiStateListener<S extends BlocEaseState> extends StatefulWidget {
  const BlocEaseMultiStateListener({
    super.key,
    required this.blocEaseBlocs,
    required this.onStateChange,
    required this.child,
  });

  /// List of Cubits that emits [BlocEaseState].
  final List<Cubit<BlocEaseState>> blocEaseBlocs;

  /// Combines all states in [states] param.
  final void Function(List<S> states) onStateChange;
  final Widget child;

  @override
  State<BlocEaseMultiStateListener<S>> createState() => _BlocEaseMultiStateListenerState<S>();
}

class _BlocEaseMultiStateListenerState<S extends BlocEaseState>
    extends State<BlocEaseMultiStateListener<S>> {
  late final StreamSubscription<BlocEaseState> _stream;

  @override
  void initState() {
    _stream = MergeStream(widget.blocEaseBlocs.map((e) => e.stream)).listen(
      (event) {
        final states = widget.blocEaseBlocs.map((e) => e.state).toList();
        final areAllStateAligningWithType = states.every((e) => e is S);
        if (areAllStateAligningWithType) {
          widget.onStateChange(states.map((e) => e as S).toList());
        }
      },
    );
    super.initState();
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
