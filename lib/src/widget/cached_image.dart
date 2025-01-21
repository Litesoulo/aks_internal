import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

/// A widget that displays an image from a URL.
class CachedImage extends StatelessWidget {
  /// Creates a widget that displays an image from a URL.
  const CachedImage({
    /// The URL of the image to display.
    required this.imageUrl,

    /// The image provider to use.
    this.cachedImageProvider,

    /// If provided, the image will be displayed in a widget created by this
    /// builder.
    this.imageBuilder,

    /// If provided, this widget will be displayed while the image is loading.
    this.placeholderBuilder,

    /// If provided, this widget will be displayed while the image is loading.
    this.progressIndicatorBuilder,

    /// If provided, this widget will be displayed if the image fails to load.
    this.errorBuilder,

    /// The width of the widget.
    this.width,

    /// The height of the widget.
    this.height,

    /// The filter quality of the image.
    this.filterQuality = FilterQuality.medium,

    /// The box fit of the image.
    this.fit,

    /// Whether to use the width to calculate the memory cache size.
    this.useWidth = true,

    /// Whether to use gapless playback.
    this.gaplessPlayback = false,

    /// The color of the image.
    this.color,
    super.key,
  });

  /// The URL of the image to display.
  final String imageUrl;

  /// The image provider to use.
  final CachedNetworkImageProvider? cachedImageProvider;

  /// If provided, the image will be displayed in a widget created by this
  /// builder.
  final OctoImageBuilder? imageBuilder;

  /// If provided, this widget will be displayed while the image is loading.
  final OctoPlaceholderBuilder? placeholderBuilder;

  /// If provided, this widget will be displayed while the image is loading.
  final OctoProgressIndicatorBuilder? progressIndicatorBuilder;

  /// If provided, this widget will be displayed if the image fails to load.
  final OctoErrorBuilder? errorBuilder;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// The filter quality of the image.
  final FilterQuality? filterQuality;

  /// The box fit of the image.
  final BoxFit? fit;

  /// Whether to use the width to calculate the memory cache size.
  final bool useWidth;

  /// Whether to use gapless playback.
  final bool gaplessPlayback;

  /// The color of the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final dpRatio = MediaQuery.devicePixelRatioOf(context);
        int? memCacheWidth;
        int? memCacheHeight;
        if (useWidth) {
          var size = width;
          if (size != null && size.isInfinite) {
            size = constraints.maxWidth;
          }
          size ??= constraints.maxWidth;
          if (!size.isInfinite) {
            memCacheHeight = (size * dpRatio).ceil();
          }
        } else {
          var size = height;
          if (size != null && size.isInfinite) {
            size = constraints.maxHeight;
          }
          size ??= constraints.maxHeight;
          if (!size.isInfinite) {
            memCacheWidth = (size * dpRatio).ceil();
          }
        }

        return OctoImage(
          width: width,
          height: height,
          image: cachedImageProvider ?? CachedNetworkImageProvider(imageUrl),
          imageBuilder: imageBuilder,
          placeholderBuilder: placeholderBuilder,
          progressIndicatorBuilder: progressIndicatorBuilder,
          errorBuilder: errorBuilder,
          gaplessPlayback: gaplessPlayback,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          filterQuality: filterQuality,
          fit: fit,
          color: color,
        );
      },
    );
  }
}
