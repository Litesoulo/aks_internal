// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infinite_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InfiniteListStore<T> on _InfiniteListStoreBase<T>, Store {
  Computed<int>? _$itemCountComputed;

  @override
  int get itemCount =>
      (_$itemCountComputed ??= Computed<int>(() => super.itemCount,
              name: '_InfiniteListStoreBase.itemCount'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_InfiniteListStoreBase.isLoading'))
          .value;
  Computed<bool>? _$isLoadingMoreComputed;

  @override
  bool get isLoadingMore =>
      (_$isLoadingMoreComputed ??= Computed<bool>(() => super.isLoadingMore,
              name: '_InfiniteListStoreBase.isLoadingMore'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: '_InfiniteListStoreBase.hasError'))
          .value;

  late final _$hasReachedMaxAtom =
      Atom(name: '_InfiniteListStoreBase.hasReachedMax', context: context);

  @override
  bool get hasReachedMax {
    _$hasReachedMaxAtom.reportRead();
    return super.hasReachedMax;
  }

  @override
  set hasReachedMax(bool value) {
    _$hasReachedMaxAtom.reportWrite(value, super.hasReachedMax, () {
      super.hasReachedMax = value;
    });
  }

  late final _$currentOffsetAtom =
      Atom(name: '_InfiniteListStoreBase.currentOffset', context: context);

  @override
  int? get currentOffset {
    _$currentOffsetAtom.reportRead();
    return super.currentOffset;
  }

  @override
  set currentOffset(int? value) {
    _$currentOffsetAtom.reportWrite(value, super.currentOffset, () {
      super.currentOffset = value;
    });
  }

  late final _$itemsAtom =
      Atom(name: '_InfiniteListStoreBase.items', context: context);

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

  late final _$_backupItemsAtom =
      Atom(name: '_InfiniteListStoreBase._backupItems', context: context);

  @override
  ObservableList<T> get _backupItems {
    _$_backupItemsAtom.reportRead();
    return super._backupItems;
  }

  @override
  set _backupItems(ObservableList<T> value) {
    _$_backupItemsAtom.reportWrite(value, super._backupItems, () {
      super._backupItems = value;
    });
  }

  late final _$itemsFutureAtom =
      Atom(name: '_InfiniteListStoreBase.itemsFuture', context: context);

  @override
  ObservableFuture<List<T>> get itemsFuture {
    _$itemsFutureAtom.reportRead();
    return super.itemsFuture;
  }

  @override
  set itemsFuture(ObservableFuture<List<T>> value) {
    _$itemsFutureAtom.reportWrite(value, super.itemsFuture, () {
      super.itemsFuture = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('_InfiniteListStoreBase.fetch', context: context);

  @override
  Future<void> fetch({bool refresh = false, bool handleError = true}) {
    return _$fetchAsyncAction
        .run(() => super.fetch(refresh: refresh, handleError: handleError));
  }

  late final _$_InfiniteListStoreBaseActionController =
      ActionController(name: '_InfiniteListStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$_InfiniteListStoreBaseActionController.startAction(
        name: '_InfiniteListStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$_InfiniteListStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasReachedMax: ${hasReachedMax},
currentOffset: ${currentOffset},
items: ${items},
itemsFuture: ${itemsFuture},
itemCount: ${itemCount},
isLoading: ${isLoading},
isLoadingMore: ${isLoadingMore},
hasError: ${hasError}
    ''';
  }
}
