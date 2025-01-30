import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// A widget that displays a list of items managed by a `DataFetcherStore`.
///
/// It supports states such as loading, empty, and error and allows customization of item rendering,
/// separators, and padding.
class DataListWidget<T> extends StatelessWidget {
  /// Creates a `DataListWidget`.
  ///
  /// [store] is the `DataFetcherStore` that manages the state of the list and fetches data.
  /// This parameter is required.
  ///
  /// [itemBuilder] is a function that defines how each list item is rendered.
  /// It takes the `BuildContext` and an item of type `T` as arguments. This parameter is required.
  ///
  /// [padding] defines the padding around the list. Defaults to `null` if not specified.
  ///
  /// [emptyBuilder] is a function for building the widget displayed when the store's `items` list is empty.
  /// If `null`, a default empty message widget is shown.
  ///
  /// [loadingBuilder] is a function for building the widget displayed when the store is in a loading state.
  /// If `null`, a default circular progress indicator is shown.
  ///
  /// [errorBuilder] is a function for building the widget displayed when an error occurs during data fetching.
  /// If `null`, a default error message widget is shown.
  ///
  /// [separatorBuilder] is a function for building the widget that separates items in the list.
  /// If `null`, the default is an empty-sized box with 8 pixels of height.
  const DataListWidget({
    required this.loadingBuilder,
    required this.store,
    this.errorBuilder,
    this.separatorBuilder,
    this.emptyBuilder,
    this.customBuilder,
    this.itemBuilder,
    this.padding,
    this.scrollDirection = Axis.vertical,
    super.key,
  }) : assert(
          itemBuilder != null || customBuilder != null,
          'Either itemBuilder or customBuilder must be provided.',
        );

  /// The store that manages the state of the list and fetches data.
  final DataFetcherStore<T> store;

  /// Padding to be applied around the list.
  final EdgeInsets? padding;

  /// Builder for rendering the empty state when there are no items to display.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Builder for rendering the loading state.
  final Widget Function(BuildContext context) loadingBuilder;

  /// Builder for rendering the error state when an error occurs during data fetch.
  final Widget Function(BuildContext context)? errorBuilder;

  /// A builder function to render each list item.
  final Widget Function(BuildContext context, T item)? itemBuilder;

  /// A builder function to render list.
  final Widget Function(BuildContext context, List<T> item)? customBuilder;

  /// Builder for rendering separators between list items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// An optional [Axis] to be used by the internal [ScrollView] that defines the axis of scroll.
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    final config = AksInternal.config;
    final builders = config.aksDefaultBuilders;
    final defaultSeparatorBuilder =
        scrollDirection == Axis.horizontal ? builders.horizontalSeparatorBuilder : builders.verticalSeparatorBuilder;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Observer(
        builder: (_) {
          if (store.isLoading) {
            return loadingBuilder.call(context);
          }

          if (store.hasError) {
            return errorBuilder?.call(context) ?? Space.empty;
          }

          if (store.items.isEmpty) {
            return emptyBuilder?.call(context) ?? Space.empty;
          }

          if (customBuilder != null) {
            return customBuilder!(context, store.items);
          }

          return ListView.separated(
            padding: padding,
            itemCount: store.items.length,
            itemBuilder: (context, index) {
              final item = store.items[index];
              return itemBuilder!(context, item);
            },
            scrollDirection: scrollDirection,
            separatorBuilder: separatorBuilder ?? defaultSeparatorBuilder,
          );
        },
      ),
    );
  }
}
