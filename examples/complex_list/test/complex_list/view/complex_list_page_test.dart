import 'package:bloc_ease/bloc_ease.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:complex_list/complex_list/cubit/complex_list_cubit.dart';
import 'package:complex_list/complex_list/models/item.dart';
import 'package:complex_list/complex_list/view/complex_list_page.dart';
import 'package:complex_list/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

class MockComplexListCubit extends MockCubit<ComplexListState>
    implements ComplexListCubit {}

extension on WidgetTester {
  Future<void> pumpListPage(Repository repository) {
    return pumpWidget(
      BlocEaseStateWidgetProvider(
        initialStateBuilder: (_) => const Placeholder(),
        loadingStateBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        failureStateBuilder: (failedState) =>
            Center(child: Text(failedState.message ?? 'Oops something went wrong!')),
        child: MaterialApp(
          home: RepositoryProvider.value(
            value: repository,
            child: const ComplexListPage(),
          ),
        ),
      ),
    );
  }

  Future<void> pumpListView(ComplexListCubit listCubit) {
    return pumpWidget(
      BlocEaseStateWidgetProvider(
        initialStateBuilder: (_) => const Placeholder(),
        loadingStateBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        failureStateBuilder: (failedState) =>
            Center(child: Text(failedState.message ?? 'Oops something went wrong!')),
        child: MaterialApp(
          home: BlocProvider.value(
            value: listCubit,
            child: const ComplexListView(),
          ),
        ),
      ),
    );
  }
}

void main() {
  const mockItems = [
    Item(id: '1', value: 'Item 1'),
    Item(id: '2', value: 'Item 2'),
    Item(id: '3', value: 'Item 3'),
  ];

  late Repository repository;
  late ComplexListCubit listCubit;

  setUp(() {
    repository = MockRepository();
    listCubit = MockComplexListCubit();
  });

  group('ListPage', () {
    testWidgets('renders ComplexListView', (tester) async {
      when(() => repository.fetchItems()).thenAnswer((_) async => []);
      await tester.pumpListPage(repository);
      expect(find.byType(ComplexListView), findsOneWidget);
    });
  });

  group('ComplexListView', () {
    testWidgets(
        'renders CircularProgressIndicator while '
        'waiting for items to load', (tester) async {
      when(() => listCubit.state).thenReturn(const ComplexListLoadingState());
      await tester.pumpListView(listCubit);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders error text '
        'when items fail to load', (tester) async {
      when(() => listCubit.state).thenReturn(ComplexListFailedState());
      await tester.pumpListView(listCubit);
      expect(find.text('Oops something went wrong!'), findsOneWidget);
    });

    testWidgets(
        'renders ComplexListView after items '
        'are finished loading', (tester) async {
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState(mockItems),
      );
      await tester.pumpListView(listCubit);
      expect(find.byType(ComplexListView), findsOneWidget);
    });
    testWidgets(
        'renders no content text when '
        'no items are present', (tester) async {
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState([]),
      );
      await tester.pumpListView(listCubit);
      expect(find.text('no content'), findsOneWidget);
    });

    testWidgets('renders three ItemTiles', (tester) async {
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState(mockItems),
      );
      await tester.pumpListView(listCubit);
      expect(find.byType(ItemTile), findsNWidgets(3));
    });

    testWidgets('deletes first item', (tester) async {
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState(mockItems),
      );
      when(() => listCubit.deleteItem('1')).thenAnswer((_) async {});
      await tester.pumpListView(listCubit);
      await tester.tap(find.byIcon(Icons.delete).first);
      verify(() => listCubit.deleteItem('1')).called(1);
    });
  });

  group('ItemTile', () {
    testWidgets('renders id and value text', (tester) async {
      const mockItem = Item(id: '1', value: 'Item 1');
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState([mockItem]),
      );
      await tester.pumpListView(listCubit);
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets(
        'renders delete icon button '
        'when item is not being deleted', (tester) async {
      const mockItem = Item(id: '1', value: 'Item 1');
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState([mockItem]),
      );
      await tester.pumpListView(listCubit);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator '
        'when item is being deleting', (tester) async {
      const mockItem = Item(id: '1', value: 'Item 1', isDeleting: true);
      when(() => listCubit.state).thenReturn(
        const ComplexListSucceedState([mockItem]),
      );
      await tester.pumpListView(listCubit);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
