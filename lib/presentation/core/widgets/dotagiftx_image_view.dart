import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/rarity_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/viewmodels/dotagiftx_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DotagiftxImageView extends StatelessWidget
    with ViewCubitMixin<DotagiftxImageCubit> {
  final String imageUrl;
  final String? rarity;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? scale;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const DotagiftxImageView({
    required this.imageUrl,
    this.rarity,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.scale,
    this.errorWidget,
    this.loadingWidget,
    super.key,
  });

  @override
  Widget buildView(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final resolvedScale = scale ?? devicePixelRatio;

    final image = BlocBuilder<DotagiftxImageCubit, String>(
      builder: (context, state) {
        String resolvedUrl;
        if (width != null && height != null) {
          final scaledWidth = (resolvedScale * width!).round();
          final scaledHeight = (resolvedScale * height!).round();
          resolvedUrl = '$state${scaledWidth}x$scaledHeight/$imageUrl';
        } else {
          resolvedUrl = '$state$imageUrl';
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
      },
    );

    // Apply rarity border if rarity is provided
    final borderColor = RarityUtils.getRarityColor(rarity);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      // Slightly smaller to account for border
      child: ClipRRect(borderRadius: BorderRadius.circular(4), child: image),
    );
  }
}
