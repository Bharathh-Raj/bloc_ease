import 'package:bloc_test/bloc_test.dart';
import 'package:complex_list/complex_list/cubit/complex_list_cubit.dart';
import 'package:complex_list/complex_list/models/item.dart';
import 'package:complex_list/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  const mockItems = [
    Item(id: '1', value: '1'),
    Item(id: '2', value: '2'),
    Item(id: '3', value: '3'),
  ];

  group('ComplexListCubit', () {
    late Repository repository;

    setUp(() {
      repository = MockRepository();
    });

    test('initial state is ComplexListState.loading', () {
      expect(
        ComplexListCubit(repository: repository).state,
        const ComplexListLoadingState(),
      );
    });

    group('fetchList', () {
      blocTest<ComplexListCubit, ComplexListState>(
        'emits ComplexListState.success after fetching list',
        setUp: () {
          when(repository.fetchItems).thenAnswer((_) async => mockItems);
        },
        build: () => ComplexListCubit(repository: repository),
        act: (cubit) => cubit.fetchList(),
        expect: () => [
          const ComplexListSucceedState(mockItems),
        ],
        verify: (_) => verify(repository.fetchItems).called(1),
      );

      blocTest<ComplexListCubit, ComplexListState>(
        'emits ComplexListState.failure after failing to fetch list',
        setUp: () {
          when(repository.fetchItems).thenThrow(Exception('Error'));
        },
        build: () => ComplexListCubit(repository: repository),
        act: (cubit) => cubit.fetchList(),
        expect: () => [ComplexListFailedState()],
        verify: (_) => verify(repository.fetchItems).called(1),
      );
    });

    group('deleteItem', () {
      blocTest<ComplexListCubit, ComplexListState>(
        'emits corrects states when deleting an item',
        setUp: () {
          when(() => repository.deleteItem('2')).thenAnswer((_) async {});
        },
        build: () => ComplexListCubit(repository: repository),
        seed: () => const ComplexListSucceedState(mockItems),
        act: (cubit) => cubit.deleteItem('2'),
        expect: () => [
          const ComplexListSucceedState([
            Item(id: '1', value: '1'),
            Item(id: '2', value: '2', isDeleting: true),
            Item(id: '3', value: '3'),
          ]),
          const ComplexListSucceedState([
            Item(id: '1', value: '1'),
            Item(id: '3', value: '3'),
          ]),
        ],
        verify: (_) => verify(() => repository.deleteItem('2')).called(1),
      );
    });
  });
}
