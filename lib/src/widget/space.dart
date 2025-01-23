import 'package:flutter/material.dart';

/// A utility class to provide consistent spacing widgets
/// in a Flutter application.
///
/// This class contains predefined constants for vertical
/// and horizontal spacers of varying sizes.
class Space {
  // Private constructor to prevent instantiation of this utility class.
  const Space._();

  /// An empty `SizedBox`, useful for placeholders or eliminating spacing.
  static const empty = SizedBox.shrink();

  /// A vertical space of 5 pixels.
  static const v5 = SizedBox(height: 5);

  /// A vertical space of 10 pixels.
  static const v10 = SizedBox(height: 10);

  /// A vertical space of 15 pixels.
  static const v15 = SizedBox(height: 15);

  /// A vertical space of 20 pixels.
  static const v20 = SizedBox(height: 20);

  /// A horizontal space of 5 pixels.
  static const h5 = SizedBox(width: 5);

  /// A horizontal space of 10 pixels.
  static const h10 = SizedBox(width: 10);

  /// A horizontal space of 15 pixels.
  static const h15 = SizedBox(width: 15);

  /// A horizontal space of 20 pixels.
  static const h20 = SizedBox(width: 20);
}
