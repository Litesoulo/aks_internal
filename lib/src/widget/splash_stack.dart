import 'package:aks_internal/aks_internal.dart';
import 'package:flutter/material.dart';

/// A widget that wraps a child with a [Stack] and adds a tap-responsive [InkWell]
/// overlay. This is useful for adding splash effects or tap interactions to any
/// widget without modifying its internal structure.
///
/// The [SplashStack] allows you to specify a custom height, width, and border radius
/// for the tap area. If no border radius is provided, it defaults to the value
/// defined in `AksInternal.constants.borderRadius`.
class SplashStack extends StatelessWidget {
  /// Constructs a [SplashStack].
  ///
  /// - [child]: The widget to be displayed as the main content.
  /// - [onTap]: A callback function that is triggered when the tap area is pressed.
  /// - [height]: The height of the [SplashStack]. If null, the height will be determined
  ///   by the child's height.
  /// - [width]: The width of the [SplashStack]. If null, the width will be determined
  ///   by the child's width.
  /// - [radius]: The border radius of the tap area. If null, it defaults to
  ///   `AksInternal.constants.borderRadius`.
  const SplashStack({
    required this.child,
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.radius,
  });

  /// The main content widget to be displayed.
  final Widget child;

  /// The height of the [SplashStack]. If null, the height will be determined
  /// by the child's height.
  final double? height;

  /// The width of the [SplashStack]. If null, the width will be determined
  /// by the child's width.
  final double? width;

  /// The border radius of the tap area. If null, it defaults to
  /// `AksInternal.constants.borderRadius`.
  final double? radius;

  /// A callback function that is triggered when the tap area is pressed.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius ?? AksInternal.constants.borderRadius),
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
