// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_fetcher_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DataFetcherStore<T> on _DataFetcherStoreBase<T>, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_DataFetcherStoreBase.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_DataFetcherStoreBase.hasError'))
          .value;

  late final _$itemsAtom =
      Atom(name: '_DataFetcherStoreBase.items', context: context);

  @override
  ObservableList<T> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<T> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$_itemsFutureAtom =
      Atom(name: '_DataFetcherStoreBase._itemsFuture', context: context);

  @override
  ObservableFuture<List<T>?> get _itemsFuture {
    _$_itemsFutureAtom.reportRead();
    return super._itemsFuture;
  }

  @override
  set _itemsFuture(ObservableFuture<List<T>?> value) {
    _$_itemsFutureAtom.reportWrite(value, super._itemsFuture, () {
      super._itemsFuture = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('_DataFetcherStoreBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  @override
  String toString() {
    return '''
items: ${items},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
