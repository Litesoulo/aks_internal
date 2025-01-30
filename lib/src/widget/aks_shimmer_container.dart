import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that provides a shimmering effect to its child or a decorated container.
///
/// This widget can be customized with various parameters, such as size, border radius,
/// colors for the shimmer effect, and a background color. If no child is provided,
/// a simple shimmering container will be displayed.
///
/// {@template shimmer_container}
/// The shimmer effect is created using the `Shimmer.fromColors` widget, and it can
/// be configured to customize the base and highlight colors, animation period, and
/// other visual aspects.
/// {@endtemplate}
class AksShimmerContainer extends StatelessWidget {
  /// Creates a [AksShimmerContainer] widget.
  ///
  /// The widget displays a shimmer effect over a container that can optionally contain
  /// a child widget. You can customize the appearance of the shimmer effect and the
  /// container through various parameters.
  ///
  /// - [width]: The width of the container.
  /// - [height]: The height of the container.
  /// - [borderRadius]: The border radius of the container.
  /// - [backgroundColor]: The background color of the container.
  /// - [baseColor]: The base color for the shimmer effect.
  /// - [highlightColor]: The highlight color for the shimmer effect.
  /// - [period]: The duration of the shimmer animation.
  /// - [child]: The child widget to be displayed inside the container.
  const AksShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.child,
  });

  /// The width of the container.
  ///
  /// If not provided, the width will be determined by the size of the child or other constraints.
  final double? width;

  /// The height of the container.
  ///
  /// If not provided, the height will be determined by the size of the child or other constraints.
  final double? height;

  /// The border radius of the container.
  ///
  /// If not provided, the default border radius from the app constants is used.
  final double? borderRadius;

  /// The background color of the container.
  ///
  /// If not provided, the primary color of the app's theme will be used.
  final Color? backgroundColor;

  /// The base color for the shimmer effect.
  ///
  /// If not provided, the primary color of the app's theme with a reduced alpha will be used.
  final Color? baseColor;

  /// The highlight color for the shimmer effect.
  ///
  /// If not provided, the primary color of the app's theme with a further reduced alpha will be used.
  final Color? highlightColor;

  /// The duration of the shimmer animation.
  ///
  /// If not provided, a default duration of 1 second is used.
  final Duration? period;

  /// The child widget to be displayed inside the container.
  ///
  /// If not provided, an empty `SizedBox` is displayed instead.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final constants = AksInternal.config.appConstants;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Shimmer.fromColors(
        baseColor: baseColor ?? context.colorScheme.primary.withValues(alpha: 0.3),
        highlightColor: highlightColor ?? context.colorScheme.primary.withValues(alpha: 0.1),
        period: period ?? const Duration(seconds: 1),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ?? context.colorScheme.primary,
            borderRadius: BorderRadius.circular(
              borderRadius ?? constants.borderRadius,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
