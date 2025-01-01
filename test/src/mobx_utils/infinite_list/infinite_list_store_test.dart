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

    // Register fallback values for mocktail
    registerFallbackValue(<int>[]);
    registerFallbackValue(0);
  });

  group('InfiniteListStore', () {
    test('Initial state is correct', () {
      expect(store.items, isEmpty);
      expect(store.hasReachedMax, isFalse);
      expect(store.currentOffset, isNull);
      expect(store.isLoading, isFalse);
      expect(store.isLoadingMore, isFalse);
      expect(store.hasError, isFalse);
    });

    test('Fetch adds items and updates offset', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => [1, 2, 3]);

      await store.fetch();

      expect(store.items, [1, 2, 3]);
      expect(store.currentOffset, 3);
      expect(store.hasReachedMax, isTrue);
    });

    test('Fetch sets hasReachedMax when fewer items are returned', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit'))).thenAnswer((_) async => [1, 2]);

      await store.fetch();

      expect(store.items, [1, 2]);
      expect(store.currentOffset, 2);
      expect(store.hasReachedMax, isTrue);
    });

    test('Fetch appends items for pagination', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      when(() => mockFetcher(offset: 30, limit: 30)).thenAnswer((_) async => [1, 2, 3]);

      await store.fetch();
      await store.fetch();

      expect(store.items, [...List.filled(30, 0), 1, 2, 3]);
      expect(store.currentOffset, 33);
      expect(store.hasReachedMax, isTrue);
    });

    test('Refresh resets state and fetches new items', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch();

      when(() => mockFetcher(offset: null, limit: any(named: 'limit'))).thenAnswer((_) async => [1, 2, 3]);
      await store.refresh();

      verify(() => mockFetcher(offset: null, limit: 30)).called(2);
      expect(store.items, [1, 2, 3]);
      expect(store.currentOffset, 3);
      expect(store.hasReachedMax, isTrue);
    });

    test('Error handling restores backup state on refresh', () async {
      when(() => mockFetcher(offset: any(named: 'offset'), limit: any(named: 'limit')))
          .thenAnswer((_) async => List.filled(30, 0));
      await store.fetch();

      when(() => mockFetcher(offset: null, limit: any(named: 'limit'))).thenAnswer((_) => Future.error('ERROR'));
      try {
        await store.refresh();
      } catch (_) {}

      verify(() => mockFetcher(offset: null, limit: 30)).called(2);
      expect(store.items, List.filled(30, 0));
      expect(store.hasError, isTrue);
    });

    test('isLoading and isLoadingMore are computed correctly', () async {
      // TODO Help needed
      throw UnimplementedError();
    });
  });
}
