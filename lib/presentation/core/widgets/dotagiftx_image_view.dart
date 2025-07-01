import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:flutter/material.dart';

class DotagiftxImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? scale;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const DotagiftxImageView({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.scale,
    this.errorWidget,
    this.loadingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final resolvedScale = scale ?? devicePixelRatio;

    String resolvedUrl;
    if (width != null && height != null) {
      final scaledWidth = (resolvedScale * width!).round();
      final scaledHeight = (resolvedScale * height!).round();
      resolvedUrl =
          '${RemoteConfigConstants.imageBaseUrl}${scaledWidth}x$scaledHeight/$imageUrl';
    } else {
      resolvedUrl = '${RemoteConfigConstants.imageBaseUrl}$imageUrl';
    }

    return Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      scale: resolvedScale,
      errorBuilder:
          (context, error, stackTrace) =>
              errorWidget ?? const Icon(Icons.broken_image),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return loadingWidget ??
            const Center(child: CircularProgressIndicator());
      },
    );
  }
}
