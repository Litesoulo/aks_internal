part of 'parse_query_builder.dart';

/// A filter that specifies an "equals" condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] matches the
/// provided [value].
///
/// Example:
/// ```dart
/// EqualsFilter(column: 'status', value: 'active');
/// ```
class EqualsFilter<T> {
  /// Creates an [EqualsFilter] with the specified [column] and [value].
  EqualsFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The value to compare with the column's value.
  final T value;
}

/// A filter that specifies a "contained in" condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] is one of
/// the values in the provided list [value].
///
/// Example:
/// ```dart
/// ContainedInFilter(column: 'tags', value: ['tag1', 'tag2']);
/// ```
class ContainedInFilter<T> {
  /// Creates a [ContainedInFilter] with the specified [column] and [value].
  ContainedInFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The list of values to check against the column's value.
  final List<T> value;
}

/// A filter that specifies a "greater than" condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] is greater
/// than the provided [value].
///
/// Example:
/// ```dart
/// GreaterThanFilter(column: 'age', value: 18);
/// ```
class GreaterThanFilter<T> {
  /// Creates a [GreaterThanFilter] with the specified [column] and [value].
  GreaterThanFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The value to compare with the column's value.
  final T value;
}

/// A filter that specifies a "less than" condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] is less
/// than the provided [value].
///
/// Example:
/// ```dart
/// LessThanFilter(column: 'price', value: 100);
/// ```
class LessThanFilter<T> {
  /// Creates a [LessThanFilter] with the specified [column] and [value].
  LessThanFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The value to compare with the column's value.
  final T value;
}

/// A filter that specifies a "not equals" condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] does not match
/// the provided [value].
///
/// Example:
/// ```dart
/// NotEqualsFilter(column: 'status', value: 'inactive');
/// ```
class NotEqualsFilter<T> {
  /// Creates a [NotEqualsFilter] with the specified [column] and [value].
  NotEqualsFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The value to compare with the column's value.
  final T value;
}

/// A filter that specifies a regex pattern condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] matches
/// the provided regex [value].
///
/// Example:
/// ```dart
/// RegexFilter(column: 'email', value: '^.*@example.com\$');
/// ```
class RegexFilter {
  /// Creates a [RegexFilter] with the specified [column] and [value].
  RegexFilter({
    required this.column,
    required this.value,
  });

  /// The column to apply the filter on.
  final String column;

  /// The regex pattern to match against the column's value.
  final String value;
}

/// A filter that specifies a relationship condition for a column in a query.
///
/// This filter ensures that the value in the specified [column] is related
/// to an object in another class, identified by [className] and [objectId].
///
/// Example:
/// ```dart
/// RelatedToFilter(
///   column: 'user',
///   className: '_User',
///   objectId: 'abc123',
/// );
/// ```
class RelatedToFilter {
  /// Creates a [RelatedToFilter] with the specified [column], [className], and [objectId].
  RelatedToFilter({
    required this.column,
    required this.objectId,
    required this.className,
  });

  /// The column to apply the filter on.
  final String column;

  /// The name of the related class.
  final String className;

  /// The object ID of the related object.
  final String objectId;
}
