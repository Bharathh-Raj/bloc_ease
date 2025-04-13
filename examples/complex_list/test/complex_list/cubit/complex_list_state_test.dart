// ignore_for_file: prefer_const_constructors
import 'package:complex_list/complex_list/cubit/complex_list_cubit.dart';
import 'package:complex_list/complex_list/models/item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComplexListState', () {
    const mockItems = [Item(id: '1', value: '1')];
    test('support value comparisons', () {
      expect(ComplexListLoadingState(), ComplexListLoadingState());
      expect(ComplexListFailureState(), ComplexListFailureState());
      expect(
        ComplexListSuccessState(mockItems),
        ComplexListSuccessState(mockItems),
      );
    });
  });
}
