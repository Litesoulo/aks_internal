import 'package:flutter/material.dart';

/// Extension methods for String to provide additional utility functions.
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.capitalize(); // 'Hello'
  /// ```
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if the string consists only of numeric characters.
  ///
  /// Returns `true` if the string is numeric, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// '12345'.isNumeric; // true
  /// 'abc123'.isNumeric; // false
  /// ```
  bool get isNumeric {
    final numericRegExp = RegExp(r'^\d+$');
    return numericRegExp.hasMatch(this);
  }

  /// Converts a comma-separated RGB string into a [Color] object.
  ///
  /// The string should be in the format "R,G,B" where R, G, and B are integers.
  ///
  /// Returns a [Color] object if the string is valid, otherwise `null`.
  ///
  /// Example:
  /// ```dart
  /// '255,0,0'.toColor(); // Color(0xFFFF0000)
  /// ```
  Color? toColor() {
    final parts = split(',');

    if (parts.length < 3) {
      return null;
    }

    final r = int.tryParse(parts[0]) ?? 0;
    final g = int.tryParse(parts[1]) ?? 0;
    final b = int.tryParse(parts[2]) ?? 0;

    return Color.fromRGBO(r, g, b, 1);
  }
}
