import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// A widget that displays a single item managed by a `SingleDataFetcherStore`.
///
/// It supports states such as loading, error, and displaying the fetched item.
class SingleDataWidget<T> extends StatelessWidget {
  /// Creates a `SingleDataWidget`.
  ///
  /// [store] is the `SingleDataFetcherStore` that manages the state of the single item.
  /// This parameter is required.
  ///
  /// [itemBuilder] is a function that defines how the single item is rendered.
  /// It takes the `BuildContext` and an item of type `T` as arguments. This parameter is required.
  ///
  /// [loadingBuilder] is a function for building the widget displayed when the store is in a loading state.
  /// If `null`, a default circular progress indicator is shown.
  ///
  /// [errorBuilder] is a function for building the widget displayed when an error occurs during data fetching.
  /// If `null`, a default error message widget is shown.
  const SingleDataWidget({
    required this.errorBuilder,
    required this.itemBuilder,
    required this.loadingBuilder,
    required this.store,
    super.key,
  });

  /// The store that manages the state of the single item.
  final SingleDataFetcherStore<T> store;

  /// Builder for rendering the loading state.
  final Widget Function(BuildContext context) loadingBuilder;

  /// Builder for rendering the error state.
  final Widget Function(BuildContext context) errorBuilder;

  /// A builder function to render the single item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Observer(
        builder: (_) {
          if (store.isLoading) {
            return loadingBuilder.call(context);
          }

          final item = store.item;
          if (store.hasError || item == null) {
            return errorBuilder.call(context);
          }

          return itemBuilder(context, item);
        },
      ),
    );
  }
}
