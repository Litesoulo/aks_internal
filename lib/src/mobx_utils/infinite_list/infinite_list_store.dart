import 'dart:async';
import 'package:mobx/mobx.dart';

part 'infinite_list_store.g.dart';

/// Type definition for the data fetcher function.
///
/// [offset] specifies the starting point for fetching data.
/// [limit] defines the maximum number of items to fetch.
/// Returns a `Future` that resolves to a list of items of type [T].
typedef InfiniteListDataFetcher<T> = Future<List<T>> Function({int? offset, int? limit});

/// A store to manage infinite scrolling lists using MobX.
///
/// This store handles paginated data fetching, maintains the state of the list,
/// and provides support for refreshing and error handling.
///
/// [T] is the type of items in the list.
class InfiniteListStore<T> = _InfiniteListStoreBase<T> with _$InfiniteListStore;

abstract class _InfiniteListStoreBase<T> with Store {
  /// Constructs an instance of [_InfiniteListStoreBase].
  ///
  /// [fetchData] is the function used to fetch data. It must be provided.
  /// [limit] specifies the number of items to fetch per page. Defaults to 30.
  _InfiniteListStoreBase({
    required this.fetchData,
    this.limit = 30,
  });

  /// The function used to fetch data.
  final InfiniteListDataFetcher<T> fetchData;

  /// The maximum number of items to fetch in a single request.
  final int limit;

  /// Total number of items currently loaded in the list.
  @computed
  int get itemCount => items.length;

  /// Indicates if a data fetch operation is currently in progress.
  @computed
  bool get isBusy => itemsFuture.status == FutureStatus.pending;

  /// Indicates if the first load of data is in progress.
  @computed
  bool get isFirstLoad => isBusy && items.isEmpty;

  /// Indicates if data is currently being paginated (loaded incrementally).
  @computed
  bool get isPaging => isBusy && items.isNotEmpty;

  /// Indicates if the last fetch operation encountered an error.
  @computed
  bool get hasError => itemsFuture.status == FutureStatus.rejected;

  /// Indicates whether all available data has been loaded.
  @observable
  bool hasReachedMax = false;

  /// The current offset for pagination, representing the starting index for the next fetch.
  @observable
  int? currentOffset;

  /// The list of items currently loaded.
  @observable
  ObservableList<T> items = ObservableList<T>.of([]);

  /// A backup of the items list, used during refresh operations.
  @observable
  ObservableList<T> _backupItems = ObservableList<T>.of([]);

  /// The future representing the current fetch operation.
  @observable
  ObservableFuture<List<T>> itemsFuture = ObservableFuture.value([]);

  /// Fetches data and updates the store's state.
  ///
  /// [refresh]: If `true`, clears the current list and reloads data.
  /// [handleError]: If `true`, restores the backup state on errors during refresh.
  @action
  Future<void> fetch({bool refresh = false, bool handleError = true}) async {
    if (hasReachedMax && !refresh) return;
    if (isBusy && !refresh) return; // Ignore concurrent fetch if not refresh
    if (isFirstLoad) return; // Prioritize refresh

    if (refresh) {
      reset(backup: handleError);
    }

    try {
      final future = fetchData(
        offset: currentOffset,
        limit: limit,
      );

      itemsFuture = ObservableFuture(future);
      final fetchedItems = await future;

      if (refresh) {
        items = ObservableList<T>.of(fetchedItems);
      } else {
        items.addAll(fetchedItems);
      }

      currentOffset = refresh ? fetchedItems.length : (currentOffset ?? 0) + fetchedItems.length;
      hasReachedMax = fetchedItems.length < limit;
    } catch (error) {
      if (handleError && refresh) {
        items = ObservableList<T>.of(_backupItems);
        currentOffset = _backupItems.length;
        hasReachedMax = false;
      }
      rethrow;
    }
  }

  /// Refreshes the list by clearing the current items and reloading data.
  @action
  Future<void> refresh() => fetch(refresh: true);

  /// Resets the store to its initial state.
  ///
  /// [backup]: If `true`, saves a backup of the current items before clearing the list.
  void reset({bool backup = true}) {
    if (backup) {
      _backupItems = ObservableList<T>.of(items);
    }
    items = ObservableList<T>.of([]);
    currentOffset = null;
    hasReachedMax = false;
  }
}
