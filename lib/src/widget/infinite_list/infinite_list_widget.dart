import 'package:aks_internal/src/mobx_utils/infinite_list/infinite_list_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

void _emptyCallback() {}

/// A generic Infinite List widget that works with [InfiniteListStore<T>].
///
/// This widget provides an infinite scrolling list that automatically loads more data
/// when the user scrolls near the end of the list. It supports displaying various
/// states like loading, empty, and error, as well as rendering list items and separators.
///
/// The widget works in conjunction with an [InfiniteListStore<T>] to manage the data and
/// fetch more items as needed.
///
class InfiniteListWidget<T> extends StatelessWidget {
  /// Constructs an [InfiniteListWidget] with the given parameters.
  ///
  /// The [store] is required and should provide the data and state for the list.
  /// The [itemBuilder] is also required to specify how each item in the list should be displayed.
  /// Other parameters like [padding], [emptyBuilder], [loadingBuilder],
  /// [errorBuilder], and [separatorBuilder] are optional and allow customization of
  /// the widget's behavior and appearance in different states.
  ///
  const InfiniteListWidget({
    required this.store,
    required this.itemBuilder,
    super.key,
    this.padding,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.separatorBuilder,
  });

  /// The store that manages the state of the infinite list and fetches data.
  final InfiniteListStore<T> store;

  /// Padding to be applied around the list.
  final EdgeInsets? padding;

  /// Builder for rendering the empty state when there are no items to display.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Builder for rendering the loading state when more items are being fetched.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Builder for rendering the error state when an error occurs during data fetch.
  final Widget Function(BuildContext context)? errorBuilder;

  /// A builder function to render each list item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Builder for rendering separators between list items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return InfiniteList(
          itemCount: store.itemCount,
          isLoading: store.isBusy,
          onFetchData: store.hasReachedMax ? _emptyCallback : store.fetch,
          separatorBuilder: separatorBuilder,
          loadingBuilder: loadingBuilder,
          emptyBuilder: emptyBuilder,
          errorBuilder: errorBuilder,
          hasError: store.hasError,
          centerEmpty: true,
          centerError: true,
          centerLoading: true,
          hasReachedMax: store.hasReachedMax,
          padding: padding,
          itemBuilder: (context, index) => itemBuilder(
            context,
            store.items[index],
          ),
        );
      },
    );
  }
}
