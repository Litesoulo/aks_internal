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
  ///
  /// [initialItem] An optional widget to display as the first item in the list.
  /// When provided, this widget is added at the beginning of the list, increasing the total item count by 1.
  /// The remaining items from the [store] will start rendering from index 1 onward.
  ///
  /// [shrinkWrap] Whether the list should shrink-wrap its contents. Defaults to `false`.
  ///
  /// [physics] The scroll physics for the list. Defines how the list responds to user input.
  /// If `null`, the default physics for the current platform is used.
  const DataListWidget({
    required this.loadingBuilder,
    required this.store,
    this.errorBuilder,
    this.separatorBuilder,
    this.emptyBuilder,
    this.customBuilder,
    this.itemBuilder,
    this.padding,
    this.initialItem,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
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

  /// An optional widget to display as the first item in the list.
  ///
  /// When provided, this widget is added at the beginning of the list, increasing the
  /// total item count by 1. The remaining items from the [store] will be rendered
  /// starting from index 1 onward using the [itemBuilder].
  final Widget? initialItem;

  /// An optional [Axis] to be used by the internal [ScrollView] that defines the axis of scroll.
  final Axis scrollDirection;

  /// Whether the list should shrink-wrap its contents.
  ///
  /// If `true`, the list takes up as little space as possible. Defaults to `false`.
  final bool shrinkWrap;

  /// The scroll physics for the list.
  ///
  /// Defines how the list responds to user input. If `null`, the platform's default is used.
  final ScrollPhysics? physics;

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
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: store.items.length + (initialItem == null ? 0 : 1),
            itemBuilder: (context, index) {
              if (initialItem != null && index == 0) {
                return initialItem!;
              }

              final idx = index - (initialItem == null ? 0 : 1);

              final item = store.items[idx];
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
