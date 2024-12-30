import 'dart:async';

import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BlocEaseCombinedStateListener<S extends BlocEaseState> extends StatefulWidget {
  const BlocEaseCombinedStateListener({
    super.key,
    required this.blocEaseCubits,
    required this.onStateChange,
    required this.child,
  });

  final List<Cubit<BlocEaseState>> blocEaseCubits;
  final void Function(List<S> states) onStateChange;
  final Widget child;

  @override
  State<BlocEaseCombinedStateListener<S>> createState() => _BlocEaseCombinedStateListenerState<S>();
}

class _BlocEaseCombinedStateListenerState<S extends BlocEaseState>
    extends State<BlocEaseCombinedStateListener<S>> {
  late final StreamSubscription<List<BlocEaseState>> _stream;

  @override
  void initState() {
    _stream = CombineLatestStream.list(widget.blocEaseCubits.map((e) => e.stream)).listen(
      (states) {
        final areAllStateAligning = states.every((e) => e is S);
        if (areAllStateAligning) {
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
