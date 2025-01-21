import 'dart:async';

import 'package:aks_internal/src/mobx_utils/data_fetcher/data_fetcher_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataFetcher extends Mock {
  Future<List<String>> call();
}

void main() {
  late MockDataFetcher mockDataFetcher;
  late DataFetcherStore<String> store;

  setUp(() {
    mockDataFetcher = MockDataFetcher();
    store = DataFetcherStore<String>(dataFetcher: mockDataFetcher.call);
  });

  group('DataFetcherStore', () {
    test('Initial state is correct', () {
      expect(store.items, isEmpty);
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });

    test('Fetch updates items on success', () async {
      // Arrange
      final fetchedItems = ['Item 1', 'Item 2', 'Item 3'];
      when(() => mockDataFetcher.call()).thenAnswer((_) async => fetchedItems);

      // Act
      await store.fetch();

      // Assert
      expect(store.items, equals(fetchedItems));
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });

    test('Fetch does not overwrite items if already loading', () async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => ['Item 1'],
        ),
      );

      unawaited(store.fetch());
      unawaited(store.fetch());

      // Assert
      verify(() => mockDataFetcher.call()).called(1); // Ensure fetch is called only once
    });

    test('Sets hasError to true if fetch fails', () async {
      // Arrange
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) => Future.error('Failed to fetch'),
      );

      // Act
      await store.fetch();

      // Assert
      // Wrap observable checks in a reaction context
      expect(store.hasError, isTrue);
      expect(store.items, isEmpty);
      expect(store.isLoading, isFalse);
    });

    test('Clears and updates items correctly on subsequent fetch', () async {
      // Arrange
      final firstFetchItems = ['Item 1', 'Item 2'];
      final secondFetchItems = ['Item 3'];

      when(() => mockDataFetcher.call()).thenAnswer((_) async => firstFetchItems);
      await store.fetch();

      when(() => mockDataFetcher.call()).thenAnswer((_) async => secondFetchItems);
      await store.fetch();

      // Assert
      expect(store.items, equals(secondFetchItems));
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });
  });
}
