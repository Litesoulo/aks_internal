import 'package:jiffy/jiffy.dart';

/// A collection of utility extensions for the [DateTime] class.
extension DateTimeExtension on DateTime {
  /// Checks if the [DateTime] is not empty and not the default value (DateTime(0)).
  ///
  /// Returns `true` if the [DateTime] is not equal to `DateTime(0)`.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023).isNotEmptyAndNotDefault; // Returns true
  /// DateTime(0).isNotEmptyAndNotDefault;    // Returns false
  /// ```
  bool get isNotEmptyAndNotDefault {
    return !isAtSameMomentAs(DateTime(0));
  }

  /// Checks if the [DateTime] is in the same month as the `other` [DateTime].
  ///
  /// Returns `true` if both dates have the same year and month.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10).isSameMonth(DateTime(2023, 10)); // Returns true
  /// DateTime(2023, 10).isSameMonth(DateTime(2023, 11)); // Returns false
  /// ```
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Checks if the [DateTime] is between the `startDate` and `endDate` (inclusive).
  ///
  /// Returns `true` if the date is equal to or after `startDate` and equal to or before `endDate`.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).isBetween(DateTime(2023, 10, 1), DateTime(2023, 10, 31)); // Returns true
  /// DateTime(2023, 11, 1).isBetween(DateTime(2023, 10, 1), DateTime(2023, 10, 31));  // Returns false
  /// ```
  bool isBetween(DateTime startDate, DateTime endDate) {
    final isAfterOrAtSameMoment = isAfter(startDate) || isAtSameMomentAs(startDate);
    final isBeforeOrAtSameMoment = isBefore(endDate) || isAtSameMomentAs(endDate);

    return isAfterOrAtSameMoment && isBeforeOrAtSameMoment;
  }

  /// Adds a specified number of days to the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 1).addDays(5); // Returns DateTime(2023, 10, 6)
  /// ```
  DateTime addDays(int days) {
    final jiffy = Jiffy.parseFromDateTime(this);
    return jiffy.add(days: days).dateTime;
  }

  /// Adds a specified number of months to the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 1).addMonths(2); // Returns DateTime(2023, 12, 1)
  /// ```
  DateTime addMonths(int months) {
    final jiffy = Jiffy.parseFromDateTime(this);
    return jiffy.add(months: months).dateTime;
  }

  /// Adds a specified number of years to the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 1).addYears(1); // Returns DateTime(2024, 10, 1)
  /// ```
  DateTime addYears(int years) {
    final jiffy = Jiffy.parseFromDateTime(this);
    return jiffy.add(years: years).dateTime;
  }

  /// Subtracts a specified number of years from the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 1).subtractYears(1); // Returns DateTime(2022, 10, 1)
  /// ```
  DateTime subtractYears(int years) {
    final jiffy = Jiffy.parseFromDateTime(this);
    return jiffy.subtract(years: years).dateTime;
  }

  /// Returns the start of the month for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).startOfMonth; // Returns DateTime(2023, 10, 1)
  /// ```
  DateTime get startOfMonth {
    return DateTime(year, month);
  }

  /// Returns the end of the month for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).endOfMonth; // Returns DateTime(2023, 10, 31, 23, 59, 59, 999, 999)
  /// ```
  DateTime get endOfMonth {
    final jiffy = Jiffy.parseFromDateTime(DateTime(year, month));
    return jiffy.add(months: 1).subtract(microseconds: 1).dateTime;
  }

  /// Returns the start of the year for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).startOfYear; // Returns DateTime(2023, 1, 1)
  /// ```
  DateTime get startOfYear {
    return DateTime(year);
  }

  /// Returns the end of the year for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).endOfYear; // Returns DateTime(2023, 12, 31, 23, 59, 59, 999, 999)
  /// ```
  DateTime get endOfYear {
    final jiffy = Jiffy.parseFromDateTime(DateTime(year));
    return jiffy.add(years: 1).subtract(microseconds: 1).dateTime;
  }

  /// Returns the start of the day for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15, 14, 30).startOfDay; // Returns DateTime(2023, 10, 15, 0, 0, 0, 0, 0)
  /// ```
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns the end of the day for the [DateTime].
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15, 14, 30).endOfDay; // Returns DateTime(2023, 10, 15, 23, 59, 59, 999, 999)
  /// ```
  DateTime get endOfDay {
    final jiffy = Jiffy.parseFromDateTime(
      DateTime(year, month, day),
    );
    return jiffy.add(days: 1).subtract(microseconds: 1).dateTime;
  }

  /// Checks if the [DateTime] is on the same day as the `other` [DateTime].
  ///
  /// Returns `true` if both dates have the same year, month, and day.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).isSameDay(DateTime(2023, 10, 15)); // Returns true
  /// DateTime(2023, 10, 15).isSameDay(DateTime(2023, 10, 16)); // Returns false
  /// ```
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if the [DateTime] is today.
  ///
  /// Returns `true` if the date is the same as the current date.
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().isToday(); // Returns true if the date is today
  /// ```
  bool isToday() {
    final other = DateTime.now();
    return year == other.year && month == other.month && day == other.day;
  }

  /// Calculates the number of days difference between this [DateTime] and the `other` [DateTime].
  ///
  /// Returns the difference in days as an integer.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2023, 10, 15).differenceInDays(DateTime(2023, 10, 10)); // Returns 5
  /// ```
  int differenceInDays(DateTime other) {
    final jiffy = Jiffy.parseFromDateTime(
      DateTime(year, month, day),
    );
    final jiffyOther = Jiffy.parseFromDateTime(other);

    return jiffy.diff(jiffyOther, unit: Unit.day).toInt();
  }
}

/// A collection of utility extensions for nullable [DateTime] objects.
extension DateTimeNullableExtension on DateTime? {
  /// Returns the value of the nullable [DateTime] or a default value (`DateTime(0)`) if it is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date;
  /// date.orDefault; // Returns DateTime(0)
  /// ```
  DateTime get orDefault => this ?? DateTime(0);
}
