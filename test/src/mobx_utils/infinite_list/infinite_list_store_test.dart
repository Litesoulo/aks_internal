import 'dart:async';

import 'package:aks_internal/src/mobx_utils/infinite_list/infinite_list_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInfiniteListDataFetcher<T> extends Mock {
  Future<List<T>> call({int? offset, int? limit});
}

void main() {
  late MockInfiniteListDataFetcher<int> mockFetcher;
  late InfiniteListStore<int> store;

  setUp(() {
    mockFetcher = MockInfiniteListDataFetcher<int>();
    store = InfiniteListStore(fetchData: mockFetcher.call);
    registerFallbackValue(<int>[]);
    registerFallbackValue(0);
  });

  group('Initial state', () {
    test('store starts with correct initial values', () {
      expect(store.items, isEmpty);
      expect(store.hasReachedMax, isFalse);
      expect(store.currentOffset, isNull);
      expect(store.isBusy, isFalse);
      expect(store.isFirstLoad, isFalse);
      expect(store.isPaging, isFalse);
      expect(store.hasError, isFalse);
      expect(store.itemCount, 0);
    });
  });

  group('Basic fetch operations', () {
    test('fetch adds items and updates offset correctly', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [1, 2, 3]);

      await store.fetch();

      expect(store.items, [1, 2, 3]);
      expect(store.currentOffset, 3);
      expect(store.hasReachedMax, isTrue);
      expect(store.itemCount, 3);
    });

    test('fetch with custom limit respects the limit parameter', () async {
      store = InfiniteListStore(fetchData: mockFetcher.call, limit: 5);

      when(() => mockFetcher(offset: any(named: 'offset'), limit: 5))
          .thenAnswer((_) async => List.generate(5, (i) => i));

      await store.fetch();

      verify(() => mockFetcher(offset: null, limit: 5)).called(1);
      expect(store.items.length, 5);
    });

    test('empty response marks list as reached max', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async => []);

      await store.fetch();

      expect(store.items, isEmpty);
      expect(store.hasReachedMax, isTrue);
      expect(store.currentOffset, 0);
    });
  });

  group('Pagination behavior', () {
    test('subsequent fetches append items correctly', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      when(() => mockFetcher(offset: 30, limit: 30)).thenAnswer((_) async => [1, 2, 3]);

      await store.fetch();
      await store.fetch();

      expect(store.items, [...List.filled(30, 0), 1, 2, 3]);
      expect(store.currentOffset, 33);
      expect(store.hasReachedMax, isTrue);
    });

    test('prevents fetch when hasReachedMax is true', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [1, 2]); // Returns less than limit

      await store.fetch(); // First fetch sets hasReachedMax
      await store.fetch(); // Should not trigger another fetch

      verify(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .called(1); // Verify fetcher was only called once
    });
  });

  group('Refresh behavior', () {
    test('refresh resets state and fetches new items', () async {
      // Initial fetch
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch();

      // Refresh with new data
      when(() => mockFetcher(offset: null, limit: any(named: 'limit'))).thenAnswer((_) async => [1, 2, 3]);
      await store.refresh();

      expect(store.items, [1, 2, 3]);
      expect(store.currentOffset, 3);
      expect(store.hasReachedMax, isTrue);
    });

    test('refresh allows fetch even when hasReachedMax is true', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [1]); // Less than limit to set hasReachedMax
      await store.fetch();

      when(() => mockFetcher(offset: null, limit: any(named: 'limit'))).thenAnswer((_) async => [2, 3, 4]);
      await store.refresh();

      expect(store.items, [2, 3, 4]);
      expect(store.hasReachedMax, isTrue);
    });
  });

  group('Error handling', () {
    test('restores backup state on refresh error', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch();

      when(() => mockFetcher(offset: null, limit: any(named: 'limit'))).thenAnswer((_) => Future.error('ERROR'));

      try {
        await store.refresh();
      } catch (_) {}

      expect(store.items, List.filled(30, 0));
      expect(store.hasError, isTrue);
    });

    test('does not restore backup on regular fetch error', () async {
      // Initial successful fetch
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch();

      // Error on next fetch
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) => Future.error('ERROR'));

      try {
        await store.fetch();
      } catch (_) {}

      expect(store.items, List.filled(30, 0)); // Original items remain
      expect(store.hasError, isTrue);
    });
  });

  group('Loading states', () {
    test('loading states are correct during first load', () async {
      final completer = Completer<List<int>>();
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) => completer.future);

      final fetchFuture = store.fetch();

      expect(store.isBusy, isTrue);
      expect(store.isFirstLoad, isTrue);
      expect(store.isPaging, isFalse);

      completer.complete([1, 2, 3]);
      await fetchFuture;

      expect(store.isBusy, isFalse);
      expect(store.isFirstLoad, isFalse);
      expect(store.isPaging, isFalse);
    });

    test('loading states are correct during pagination', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch(); // Initial fetch

      final completer = Completer<List<int>>();
      when(() => mockFetcher(offset: 30, limit: any(named: 'limit'))).thenAnswer((_) => completer.future);

      final fetchFuture = store.fetch();

      expect(store.isBusy, isTrue);
      expect(store.isFirstLoad, isFalse);
      expect(store.isPaging, isTrue);

      completer.complete([4, 5, 6]);
      await fetchFuture;

      expect(store.isBusy, isFalse);
      expect(store.isFirstLoad, isFalse);
      expect(store.isPaging, isFalse);
    });

    test('loading states are reset after error', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) => Future.error('Error'));

      try {
        await store.fetch();
      } catch (_) {}

      expect(store.isBusy, isFalse);
      expect(store.isFirstLoad, isFalse);
      expect(store.isPaging, isFalse);
      expect(store.hasError, isTrue);
    });

    test('fetch prevents concurrent execution', () async {
      final completer = Completer<List<int>>();
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) => completer.future);

      final fetch1 = store.fetch();
      final fetch2 = store.fetch();

      completer.complete([1, 2, 3]);
      await Future.wait([fetch1, fetch2]);

      verify(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).called(1);
    });
    test('refresh waits for ongoing fetch to complete', () async {
      // Simulate initial fetch to populate the store
      when(() => mockFetcher(offset: null, limit: 30)).thenAnswer((_) async => List.generate(30, (i) => i));
      await store.fetch();

      // Validate initial state after the first fetch
      expect(store.items, List.generate(30, (i) => i));
      expect(store.currentOffset, 30);

      final completerFetch = Completer<List<int>>();
      final completerRefresh = Completer<List<int>>();

      // Set up mock for fetch
      when(() => mockFetcher(offset: 30, limit: 30)).thenAnswer((_) => completerFetch.future);

      // Set up mock for refresh
      when(() => mockFetcher(offset: null, limit: 30)).thenAnswer((_) => completerRefresh.future);

      // Trigger fetch and refresh
      final fetchFuture = store.fetch();
      final refreshFuture = store.refresh();

      // Complete fetch (should not affect the result since refresh is prioritized)
      completerFetch.complete(List.generate(30, (i) => i));

      // Complete refresh with new data
      completerRefresh.complete([1, 2, 3]);

      // Wait for both to finish
      await Future.wait([fetchFuture, refreshFuture]);

      // Assert refresh result takes precedence
      expect(store.items, [1, 2, 3]); // Only refresh items should be present
      expect(store.currentOffset, 3);
    });
  });
}
