import 'package:aks_internal/aks_internal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExtension Tests', () {
    test('isNotEmptyAndNotDefault should return true for non-default DateTime', () {
      final date = DateTime(2023);
      expect(date.isNotEmptyAndNotDefault, isTrue);
    });

    test('isNotEmptyAndNotDefault should return false for default DateTime', () {
      final date = DateTime(0);
      expect(date.isNotEmptyAndNotDefault, isFalse);
    });

    test('isSameMonth should return true for dates in the same month', () {
      final date1 = DateTime(2023, 10, 15);
      final date2 = DateTime(2023, 10, 20);
      expect(date1.isSameMonth(date2), isTrue);
    });

    test('isSameMonth should return false for dates in different months', () {
      final date1 = DateTime(2023, 10, 15);
      final date2 = DateTime(2023, 11, 15);
      expect(date1.isSameMonth(date2), isFalse);
    });

    test('isBetween should return true for a date within the range', () {
      final date = DateTime(2023, 10, 15);
      final startDate = DateTime(2023, 10, 1);
      final endDate = DateTime(2023, 10, 31);
      expect(date.isBetween(startDate, endDate), isTrue);
    });

    test('isBetween should return false for a date outside the range', () {
      final date = DateTime(2023, 11, 1);
      final startDate = DateTime(2023, 10, 1);
      final endDate = DateTime(2023, 10, 31);
      expect(date.isBetween(startDate, endDate), isFalse);
    });

    test('addDays should add the specified number of days', () {
      final date = DateTime(2023, 10, 1);
      final newDate = date.addDays(5);
      expect(newDate, DateTime(2023, 10, 6));
    });

    test('addMonths should add the specified number of months', () {
      final date = DateTime(2023, 10, 1);
      final newDate = date.addMonths(2);
      expect(newDate, DateTime(2023, 12, 1));
    });

    test('addYears should add the specified number of years', () {
      final date = DateTime(2023, 10, 1);
      final newDate = date.addYears(1);
      expect(newDate, DateTime(2024, 10, 1));
    });

    test('subtractYears should subtract the specified number of years', () {
      final date = DateTime(2023, 10, 1);
      final newDate = date.subtractYears(1);
      expect(newDate, DateTime(2022, 10, 1));
    });

    test('startOfMonth should return the first day of the month', () {
      final date = DateTime(2023, 10, 15);
      expect(date.startOfMonth, DateTime(2023, 10));
    });

    test('endOfMonth should return the last day of the month', () {
      final date = DateTime(2023, 10, 15);
      expect(date.endOfMonth, DateTime(2023, 10, 31, 23, 59, 59, 999, 999));
    });

    test('startOfYear should return the first day of the year', () {
      final date = DateTime(2023, 10, 15);
      expect(date.startOfYear, DateTime(2023, 1, 1));
    });

    test('endOfYear should return the last day of the year', () {
      final date = DateTime(2023, 10, 15);
      expect(date.endOfYear, DateTime(2023, 12, 31, 23, 59, 59, 999, 999));
    });

    test('startOfDay should return the start of the day', () {
      final date = DateTime(2023, 10, 15, 14, 30);
      expect(date.startOfDay, DateTime(2023, 10, 15, 0, 0, 0, 0, 0));
    });

    test('endOfDay should return the end of the day', () {
      final date = DateTime(2023, 10, 15, 14, 30);
      expect(date.endOfDay, DateTime(2023, 10, 15, 23, 59, 59, 999, 999));
    });

    test('isSameDay should return true for the same day', () {
      final date1 = DateTime(2023, 10, 15);
      final date2 = DateTime(2023, 10, 15);
      expect(date1.isSameDay(date2), isTrue);
    });

    test('isSameDay should return false for different days', () {
      final date1 = DateTime(2023, 10, 15);
      final date2 = DateTime(2023, 10, 16);
      expect(date1.isSameDay(date2), isFalse);
    });

    test('isToday should return true if the date is today', () {
      final today = DateTime.now();
      expect(today.isToday(), isTrue);
    });

    test('isToday should return false if the date is not today', () {
      final notToday = DateTime(2023, 10, 15);
      expect(notToday.isToday(), isFalse);
    });

    test('differenceInDays should return the correct number of days', () {
      final date1 = DateTime(2023, 10, 15);
      final date2 = DateTime(2023, 10, 10);
      expect(date1.differenceInDays(date2), 5);
    });
  });

  group('DateTimeNullableExtension Tests', () {
    test('orDefault should return the default DateTime for null', () {
      DateTime? date;
      expect(date.orDefault, DateTime(0));
    });

    test('orDefault should return the original DateTime for non-null', () {
      final date = DateTime(2023, 10, 15);
      expect(date.orDefault, date);
    });
  });
}
