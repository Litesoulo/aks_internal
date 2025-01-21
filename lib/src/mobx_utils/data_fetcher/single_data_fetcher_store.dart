import 'dart:async';
import 'package:mobx/mobx.dart';

part 'single_data_fetcher_store.g.dart';

/// A typedef for the data fetching function that returns a `Future`
/// containing a single item of type `T`.
typedef SingleDataFetcher<T> = Future<T> Function();

/// A MobX store to manage the state of asynchronous data fetching for a single item.
///
/// This store provides utilities to fetch data, observe the loading state,
/// and handle errors automatically.
class SingleDataFetcherStore<T> = _SingleDataFetcherStoreBase<T> with _$SingleDataFetcherStore;

abstract class _SingleDataFetcherStoreBase<T> with Store {
  /// Creates a new instance of the single data fetcher store.
  ///
  /// [dataFetcher] is a required function that fetches a single item asynchronously.
  _SingleDataFetcherStoreBase({
    required Future<T> Function() dataFetcher,
  }) : _dataFetcher = dataFetcher;

  /// The function responsible for fetching data asynchronously.
  final SingleDataFetcher<T> _dataFetcher;

  /// The observable item fetched by the store.
  @observable
  T? item;

  /// The observable future representing the current or most recent fetch operation.
  ///
  /// This can be used to check the status of the fetch operation
  /// (e.g., pending, fulfilled, or rejected).
  @observable
  ObservableFuture<T?> _itemFuture = ObservableFuture.value(null);

  /// A backup of the current `item`, used in case the fetch fails.
  T? _backupItem;

  /// Whether the store is currently loading data.
  ///
  /// Returns `true` if a fetch operation is in progress.
  @computed
  bool get isLoading => _itemFuture.status == FutureStatus.pending;

  /// Whether the store has encountered an error during the most recent fetch operation.
  ///
  /// Returns `true` if the fetch operation failed.
  @computed
  bool get hasError => _itemFuture.status == FutureStatus.rejected;

  /// Fetches data using the provided data fetching function.
  ///
  /// If a fetch operation is already in progress, this method does nothing.
  /// The fetched item is stored in the [item] observable.
  /// If the fetch operation fails, the previous item is restored.
  @action
  Future<void> fetch() async {
    // Prevent fetching if a fetch operation is already in progress.
    if (isLoading) return;

    // Back up the current item in case the fetch fails.
    _backupItem = item;

    try {
      // Start the fetch operation.
      _itemFuture = ObservableFuture(_dataFetcher());

      // Wait for the fetch operation to complete.
      final fetchedItem = await _itemFuture;

      // Update the item with the fetched data.
      item = fetchedItem;
    } catch (e) {
      // If an error occurs, restore the previous item.
      item = _backupItem;
    }
  }
}
