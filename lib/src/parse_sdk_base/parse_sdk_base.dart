import 'package:aks_internal/src/parse_sdk_base/parse_error_exception.dart';
import 'package:aks_internal/src/parse_sdk_base/parse_filter/parse_query_builder.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

/// Base class for interacting with Parse Server objects of type [T].
abstract base class ParseSdkBase<T extends ParseObject> {
  /// Constructs a [ParseSdkBase] instance.
  ///
  /// This constructor requires a [ParseObjectConstructor], which is a function
  /// that generates new instances of the [ParseObject] type [T]. The constructor
  /// initializes the [_objectConstructor] that is used internally to perform
  /// operations on Parse objects.
  ///
  /// - [objectConstructor]: A function that returns an instance of the [ParseObject]
  ///   to be managed by this class.
  ParseSdkBase({
    required ParseObjectConstructor objectConstructor,
  }) : _objectConstructor = objectConstructor;

  final ParseObjectConstructor _objectConstructor;

  /// Fetches a [ParseObject] of type [T] by its [id].
  Future<T> fetchById(String id) async {
    final response = await _objectConstructor().getObject(id);
    return _processSingleResponse(response);
  }

  /// Updates an existing [ParseObject] of type [T].
  Future<T> update(T item) async {
    final response = await item.save();
    return _processSingleResponse(response);
  }

  /// Creates a new [ParseObject] of type [T].
  Future<T> create(T item) async {
    final response = await item.create();
    return _processSingleResponse(response);
  }

  /// Removes a [ParseObject] of type [T].
  Future<void> remove(T item) async {
    final response = await item.delete();
    if (!response.success) {
      throw ParseErrorException(parseError: response.error);
    }
  }

  /// Fetches a list of [ParseObject]s of type [T] based on the [ParseQueryBuilder].
  Future<List<T>> fetchList({
    required ParseQueryBuilder parseQueryBuilder,
    int? limit,
    int? offset,
  }) async {
    final query = _buildQuery(limit: limit, offset: offset, builder: parseQueryBuilder);
    final response = await query.query();
    return _processListResponse(response);
  }

  /// Constructs a [QueryBuilder] based on the provided [ParseQueryBuilder].
  QueryBuilder<T> _buildQuery({
    int? limit,
    int? offset,
    required ParseQueryBuilder builder,
  }) {
    final query = QueryBuilder<T>(_objectConstructor() as T);

    if (offset != null) {
      query.setAmountToSkip(offset);
    }

    if (limit != null) {
      query.setLimit(limit);
    }

    _applySorting(query, builder);
    _applyFilters(query, builder);

    return query;
  }

  /// Applies sorting options to the [QueryBuilder].
  void _applySorting(QueryBuilder<T> query, ParseQueryBuilder builder) {
    builder.orderByAscendingKeys?.forEach(query.orderByAscending);
    builder.orderByDescendingKeys?.forEach(query.orderByDescending);
  }

  /// Applies filters to the [QueryBuilder].
  void _applyFilters(QueryBuilder<T> query, ParseQueryBuilder builder) {
    if (builder.keysToInclude != null) {
      query.includeObject(builder.keysToInclude!);
    }

    builder.containedInFilters?.forEach(
      (filter) => query.whereContainedIn(filter.column, filter.value),
    );

    if (builder.returnKeysFilter != null) {
      query.keysToReturn(builder.returnKeysFilter!);
    }
    builder.notEqualsFilters?.forEach(
      (filter) => query.whereNotEqualTo(filter.column, filter.value),
    );

    builder.equalsFilters?.forEach(
      (filter) => query.whereEqualTo(filter.column, filter.value),
    );

    builder.greaterThanFilters?.forEach(
      (filter) => query.whereGreaterThanOrEqualsTo(filter.column, filter.value),
    );

    builder.lessThanFilters?.forEach(
      (filter) => query.whereLessThanOrEqualTo(filter.column, filter.value),
    );

    if (builder.regexFilter != null) {
      query.regEx(builder.regexFilter!.column, builder.regexFilter!.value);
    }

    if (builder.relatedToFilter != null) {
      final relatedFilter = builder.relatedToFilter!;
      query.whereRelatedTo(
        relatedFilter.column,
        relatedFilter.className,
        relatedFilter.objectId,
      );
    }
  }

  /// Processes the response from a single [ParseObject] operation.
  T _processSingleResponse(ParseResponse response) {
    if (!response.success || response.results?.firstOrNull == null) {
      throw ParseErrorException(parseError: response.error);
    }

    return response.results!.firstOrNull as T;
  }

  /// Processes the response from a list query.
  List<T> _processListResponse(ParseResponse response) {
    if (!response.success) {
      throw ParseErrorException(parseError: response.error);
    }

    return response.results?.cast<T>() ?? [];
  }
}
