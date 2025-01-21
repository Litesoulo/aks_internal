// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_data_fetcher_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SingleDataFetcherStore<T> on _SingleDataFetcherStoreBase<T>, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_SingleDataFetcherStoreBase.isLoading'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_SingleDataFetcherStoreBase.hasError'))
          .value;

  late final _$itemAtom =
      Atom(name: '_SingleDataFetcherStoreBase.item', context: context);

  @override
  T? get item {
    _$itemAtom.reportRead();
    return super.item;
  }

  @override
  set item(T? value) {
    _$itemAtom.reportWrite(value, super.item, () {
      super.item = value;
    });
  }

  late final _$_itemFutureAtom =
      Atom(name: '_SingleDataFetcherStoreBase._itemFuture', context: context);

  @override
  ObservableFuture<T?> get _itemFuture {
    _$_itemFutureAtom.reportRead();
    return super._itemFuture;
  }

  @override
  set _itemFuture(ObservableFuture<T?> value) {
    _$_itemFutureAtom.reportWrite(value, super._itemFuture, () {
      super._itemFuture = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('_SingleDataFetcherStoreBase.fetch', context: context);

  @override
  Future<void> fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  @override
  String toString() {
    return '''
item: ${item},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
