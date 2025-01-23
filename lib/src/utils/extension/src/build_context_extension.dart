import 'package:flutter/material.dart';

/// Extension methods on [BuildContext] to simplify access to common properties.
extension BuildContextExtension on BuildContext {
  /// Returns the [TextTheme] of the current [BuildContext].
  ///
  /// Provides access to typography styles such as headings, body text, etc.
  TextTheme get textTheme => TextTheme.of(this);

  /// Returns the [ThemeData] of the current [BuildContext].
  ///
  /// Provides access to the theme, including colors, fonts, and styles.
  ThemeData get theme => Theme.of(this);

  /// Returns the [ColorScheme] of the current [BuildContext].
  ///
  /// Provides access to the app's color palette defined in the theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the [MediaQueryData] of the current [BuildContext].
  ///
  /// Provides information about the device's screen dimensions, padding, etc.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [Size] of the current screen.
  ///
  /// Represents the dimensions (width and height) of the device screen.
  Size get size => MediaQuery.sizeOf(this);

  /// Returns the width of the current screen.
  ///
  /// A shorthand for `size.width`.
  double get width => size.width;

  /// Returns the height of the current screen.
  ///
  /// A shorthand for `size.height`.
  double get height => size.height;
}
