import 'package:flutter/material.dart';

/// A class for holding application constants.
///
/// Use this to define and share default widgets like separators
/// or other UI-related constants throughout the app.
class AksAppConstants {
  /// Creates an instance of [AksAppConstants].
  ///
  /// Requires [defaultVerticalSeparator] and [defaultHorizontalSeparator] to initialize.
  AksAppConstants({
    required this.defaultVerticalSeparator,
    required this.defaultHorizontalSeparator,
  });

  /// The default vertical separator widget.
  ///
  /// Typically used to provide consistent vertical spacing across the app.
  final Widget defaultVerticalSeparator;

  /// The default horizontal separator widget.
  ///
  /// Typically used to provide consistent horizontal spacing across the app.
  final Widget defaultHorizontalSeparator;
}
