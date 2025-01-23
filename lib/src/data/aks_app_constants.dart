import 'package:flutter/material.dart';

/// A class for holding application constants.
///
/// Use this to define and share default widgets like separators
/// or other UI-related constants throughout the app.
class AksAppConstants {
  /// Creates an instance of [AksAppConstants].
  ///
  /// Requires [verticalSeparator], [horizontalSeparator], [borderRadius],
  /// [padding], and [animationDuration] to initialize.
  AksAppConstants({
    required this.verticalSeparator,
    required this.horizontalSeparator,
    required this.borderRadius,
    required this.padding,
    required this.animationDuration,
  });

  /// The default vertical separator widget.
  ///
  /// Typically used to provide consistent vertical spacing across the app.
  final Widget verticalSeparator;

  /// The default horizontal separator widget.
  ///
  /// Typically used to provide consistent horizontal spacing across the app.
  final Widget horizontalSeparator;

  /// The base border radius value.
  ///
  /// This can be customized using the provided getters for different levels.
  final double borderRadius;

  /// The base padding value.
  ///
  /// This can be customized using the provided getters for different levels.
  final double padding;

  /// The default animation duration for transitions or animations.
  final Duration animationDuration;

  /// A small border radius.
  double get borderRadiusSmall => borderRadius * 0.5;

  /// A large border radius.
  double get borderRadiusLarge => borderRadius * 2;

  /// A small padding value.
  double get paddingSmall => padding * 0.5;

  /// A large padding value.
  double get paddingLarge => padding * 2;
}
