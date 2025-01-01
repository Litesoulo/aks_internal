import 'package:mobx/mobx.dart';

part 'infinite_list_store.g.dart';

/// A function type for fetching paginated data for an infinite list.
///
/// [offset] specifies the starting point for fetching items.
/// [limit] specifies the maximum number of items to fetch in one request.
///
/// Returns a [Future] containing a list of items of type [T].
typedef InfiniteListDataFetcher<T> = Future<List<T>> Function({int? offset, int? limit});

/// A MobX store for managing infinite scrolling data.
///
/// This store handles fetching, refreshing, and paginating data while maintaining state consistency.
/// It supports error handling, and ensures data can be restored to the last valid state when an error occurs.
///
/// [T] specifies the type of items being managed.
class InfiniteListStore<T> = _InfiniteListStoreBase<T> with _$InfiniteListStore;

abstract class _InfiniteListStoreBase<T> with Store {
  /// Creates an instance of [InfiniteListStore].
  ///
  /// [fetchData] is the function used to fetch data for the list.
  /// [limit] defines the maximum number of items to fetch per request (default is 30).
  _InfiniteListStoreBase({
    required this.fetchData,
    this.limit = 30,
  });

  /// The function used to fetch data for the list.
  final InfiniteListDataFetcher<T> fetchData;

  /// The maximum number of items to fetch per request.
  final int limit;

  /// The total number of items currently in the list.
  @computed
  int get itemCount => items.length;

  /// Indicates whether the store is currently loading initial data.
  @computed
  bool get isLoading => itemsFuture.status == FutureStatus.pending && items.isEmpty;

  /// Indicates whether the store is loading more data (pagination).
  @computed
  bool get isLoadingMore => itemsFuture.status == FutureStatus.pending && items.isNotEmpty;

  /// Indicates if the last fetch operation resulted in an error.
  @computed
  bool get hasError => itemsFuture.status == FutureStatus.rejected;

  /// Whether the end of the data has been reached.
  @readonly
  bool hasReachedMax = false;

  /// The current offset for the next fetch operation.
  @readonly
  int? currentOffset;

  /// The items currently in the list.
  @readonly
  ObservableList<T> items = ObservableList.of([]);

  /// A backup of the last valid state of the items.
  @readonly
  ObservableList<T> _backupItems = ObservableList.of([]);

  /// The current future representing the fetch operation.
  @readonly
  ObservableFuture<List<T>> itemsFuture = ObservableFuture.value([]);

  /// Fetches items from the data source and updates the store.
  ///
  /// If [refresh] is true, the store resets before fetching new data.
  /// If [hasReachedMax] is true and [refresh] is false, the fetch is skipped.
  /// If [handleError] is true, restores the last valid state in case of an error.
  @action
  Future<void> fetch({bool refresh = false, bool handleError = true}) async {
    if (hasReachedMax && !refresh) return;

    if (isLoadingMore) return;

    if (refresh) {
      reset(backup: handleError);
    }

    try {
      itemsFuture = ObservableFuture(
        fetchData(
          offset: currentOffset,
          limit: limit,
        ),
      );

      final fetchedItems = await itemsFuture;
      items.addAll(fetchedItems);

      currentOffset = (currentOffset ?? 0) + fetchedItems.length;
      hasReachedMax = fetchedItems.length < limit;
    } catch (_) {
      if (handleError && refresh) {
        items = _backupItems;
      }

      rethrow;
    }
  }

  /// Refreshes the store by fetching the latest data.
  ///
  /// This method is a shortcut for calling [fetch] with [refresh] set to true.
  @action
  Future<void> refresh() => fetch(refresh: true);

  /// Resets the store to its initial state.
  ///
  /// Clears the current items, offset, and related states while optionally backing up the existing state.
  /// If [backup] is false, the previous state will not be saved.
  void reset({bool backup = true}) {
    if (backup) {
      _backupItems = items;
    }
    items = ObservableList.of(<T>[]);
    currentOffset = null;
    hasReachedMax = false;
  }
}
