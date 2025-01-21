import 'dart:async';

import 'package:aks_internal/aks_internal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSingleDataFetcher extends Mock {
  Future<String> call();
}

void main() {
  late MockSingleDataFetcher mockDataFetcher;
  late SingleDataFetcherStore<String> store;

  setUp(() {
    mockDataFetcher = MockSingleDataFetcher();
    store = SingleDataFetcherStore<String>(dataFetcher: mockDataFetcher.call);
  });

  group('SingleDataFetcherStore', () {
    test('Initial state is correct', () {
      // Assert
      expect(store.item, isNull);
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });

    test('Fetch updates item on success', () async {
      // Arrange
      const fetchedItem = 'Fetched Item';
      when(() => mockDataFetcher.call()).thenAnswer((_) async => fetchedItem);

      // Act
      await store.fetch();

      // Assert
      expect(store.item, equals(fetchedItem));
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });

    test('Fetch does not overwrite item if already loading', () async {
      // Arrange
      const fetchedItem = 'Fetched Item';
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) async => Future.delayed(const Duration(milliseconds: 100), () => fetchedItem),
      );

      // Act
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
      expect(store.hasError, isTrue);
      expect(store.item, isNull);
      expect(store.isLoading, isFalse);
    });

    test('Restores previous item if fetch fails', () async {
      // Arrange
      const previousItem = 'Previous Item';

      // First fetch (successful)
      when(() => mockDataFetcher.call()).thenAnswer((_) async => previousItem);
      await store.fetch();

      // Second fetch (fails)
      when(() => mockDataFetcher.call()).thenAnswer(
        (_) async => Future.error('Error occured'),
      );

      // Act
      await store.fetch();

      // Assert
      expect(store.item, equals(previousItem)); // Previous item should remain
      expect(store.hasError, isTrue);
    });

    test('Fetch updates item correctly on subsequent fetch', () async {
      // Arrange
      const firstItem = 'First Item';
      const secondItem = 'Second Item';

      when(() => mockDataFetcher.call()).thenAnswer((_) async => firstItem);
      await store.fetch();

      when(() => mockDataFetcher.call()).thenAnswer((_) async => secondItem);

      // Act
      await store.fetch();

      // Assert
      expect(store.item, equals(secondItem));
      expect(store.isLoading, isFalse);
      expect(store.hasError, isFalse);
    });
  });
}
