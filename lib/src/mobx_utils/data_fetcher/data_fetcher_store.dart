import 'dart:async';
import 'package:mobx/mobx.dart';

part 'data_fetcher_store.g.dart';

/// A typedef for the data fetching function that returns a `Future`
/// containing a list of items of type `T`.
typedef DataFetcher<T> = Future<List<T>> Function();

/// A MobX store to manage the state of asynchronous data fetching.
///
/// This store provides utilities to fetch data, observe the loading state,
/// and handle errors automatically.
class DataFetcherStore<T> = _DataFetcherStoreBase<T> with _$DataFetcherStore;

abstract class _DataFetcherStoreBase<T> with Store {
  /// Creates a new instance of the data fetcher store.
  ///
  /// [dataFetcher] is a required function that fetches a list of items asynchronously.
  _DataFetcherStoreBase({
    required Future<List<T>> Function() dataFetcher,
  }) : _dataFetcher = dataFetcher;

  /// The function responsible for fetching data asynchronously.
  final DataFetcher<T> _dataFetcher;

  /// The observable list of items fetched by the store.
  @observable
  ObservableList<T> items = ObservableList<T>.of([]);

  /// The observable future representing the current or most recent fetch operation.
  ///
  /// This can be used to check the status of the fetch operation
  /// (e.g., pending, fulfilled, or rejected).
  @observable
  ObservableFuture<List<T>?> _itemsFuture = ObservableFuture.value(null);

  /// A backup of the current `items`, used in case the fetch fails.
  List<T> _backupItems = [];

  /// Whether the store is currently loading data.
  ///
  /// Returns `true` if a fetch operation is in progress.
  @computed
  bool get isLoading => _itemsFuture.status == FutureStatus.pending;

  /// Whether the store has encountered an error during the most recent fetch operation.
  ///
  /// Returns `true` if the fetch operation failed.
  @computed
  bool get hasError => _itemsFuture.status == FutureStatus.rejected;

  /// Fetches data using the provided data fetching function.
  ///
  /// If a fetch operation is already in progress, this method does nothing.
  /// The fetched items are stored in the [items] observable list.
  /// If the fetch operation fails, the previous items are restored.
  @action
  Future<void> fetch() async {
    // Prevent fetching if a fetch operation is already in progress.
    if (isLoading) return;

    // Back up the current items in case the fetch fails.
    _backupItems = List<T>.from(items);

    try {
      // Start the fetch operation.
      _itemsFuture = ObservableFuture(_dataFetcher());

      // Wait for the fetch operation to complete.
      final fetchedItems = await _itemsFuture;

      // Update the items with the fetched data.
      items
        ..clear()
        ..addAll(fetchedItems ?? []);
    } catch (e) {
      // If an error occurs, restore the previous items.
      items
        ..clear()
        ..addAll(_backupItems);
    }
  }
}
