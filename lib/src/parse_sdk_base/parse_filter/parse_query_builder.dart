// ignore_for_file: strict_raw_type

part '_parse_query_builder.dart';

/// A builder class to construct queries for interacting with the Parse Server.
///
/// This class allows for flexible query construction by providing various
/// filters, sorting options, and other query-related configurations.
class ParseQueryBuilder {
  /// Constructs a [ParseQueryBuilder] instance with optional filters and configurations.
  ///
  /// - [containedInFilters]: Specifies filters for "contained in" conditions.
  /// - [greaterThanFilters]: Specifies filters for "greater than" conditions.
  /// - [lessThanFilters]: Specifies filters for "less than" conditions.
  /// - [notEqualsFilters]: Specifies filters for "not equals" conditions.
  /// - [equalsFilters]: Specifies filters for "equals" conditions.
  /// - [returnKeysFilter]: Specifies which keys should be returned in the query results.
  /// - [regexFilter]: Specifies a regex filter for applying pattern-based conditions.
  /// - [relatedToFilter]: Specifies a filter for querying related objects.
  /// - [keysToInclude]: Specifies keys to include for nested objects in the results.
  /// - [orderByAscendingKeys]: Specifies keys for sorting results in ascending order.
  /// - [orderByDescendingKeys]: Specifies keys for sorting results in descending order.
  ParseQueryBuilder({
    this.containedInFilters,
    this.returnKeysFilter,
    this.greaterThanFilters,
    this.lessThanFilters,
    this.notEqualsFilters,
    this.equalsFilters,
    this.regexFilter,
    this.relatedToFilter,
    this.keysToInclude,
    this.orderByAscendingKeys,
    this.orderByDescendingKeys,
  });

  /// Filters to specify columns and values for "contained in" conditions.
  final List<ContainedInFilter>? containedInFilters;

  /// Filters to specify columns and values for "greater than" conditions.
  final List<GreaterThanFilter>? greaterThanFilters;

  /// Filters to specify columns and values for "less than" conditions.
  final List<LessThanFilter>? lessThanFilters;

  /// Filters to specify columns and values for "not equals" conditions.
  final List<NotEqualsFilter>? notEqualsFilters;

  /// Filters to specify columns and values for "equals" conditions.
  final List<EqualsFilter>? equalsFilters;

  /// Specifies the keys to return in the query results.
  final List<String>? returnKeysFilter;

  /// A filter to apply regex-based conditions to a column.
  final RegexFilter? regexFilter;

  /// A filter to specify relationships between objects in different classes.
  final RelatedToFilter? relatedToFilter;

  /// A list of keys to include in the query results for nested objects.
  final List<String>? keysToInclude;

  /// A list of keys to sort the query results in ascending order.
  final List<String>? orderByAscendingKeys;

  /// A list of keys to sort the query results in descending order.
  final List<String>? orderByDescendingKeys;
}
