import 'package:flutter/material.dart';

/// A class that holds builder functions for default widgets used across the app.
///
/// This allows customizing the separator widgets with custom builders for horizontal and vertical separators.
///
/// Use this class to pass custom builder functions for separators in different parts of the app.
///
/// The [horizontalSeparatorBuilder] and [verticalSeparatorBuilder] can be provided
/// to customize the separators' appearance based on the current context and index.
class AksDefaultBuilders {
  /// Constructs an instance of [AksDefaultBuilders].
  ///
  /// - [horizontalSeparatorBuilder]: A builder function for creating a custom horizontal separator widget.
  /// - [verticalSeparatorBuilder]: A builder function for creating a custom vertical separator widget.
  /// - [errorImageBuilder]: A builder function for creating a custom widget when an image is unavailable.
  AksDefaultBuilders({
    required this.horizontalSeparatorBuilder,
    required this.verticalSeparatorBuilder,
    this.errorImageBuilder,
  });

  /// A builder function for creating a custom horizontal separator widget.
  ///
  /// This function provides the current [BuildContext] and the index of the item in the list, which can be
  /// used to create customized horizontal separator widgets.
  final Widget Function(BuildContext, int) horizontalSeparatorBuilder;

  /// A builder function for creating a custom vertical separator widget.
  ///
  /// Similar to [horizontalSeparatorBuilder], but for vertical separators. The function provides the
  /// [BuildContext] and the index to create vertical separators dynamically.
  final Widget Function(BuildContext, int) verticalSeparatorBuilder;

  /// A builder function for creating a custom widget when an image is unavailable.
  ///
  /// This function provides the [BuildContext] and allows defining a placeholder widget to display when
  /// there is no image available. If not provided, no default widget is used.
  final Widget Function(BuildContext)? errorImageBuilder;
}
