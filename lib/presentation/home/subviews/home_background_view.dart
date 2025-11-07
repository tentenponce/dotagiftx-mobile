import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/core/utils/url_utils.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBackgroundView extends StatelessWidget {
  final Widget child;
  const HomeBackgroundView({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen:
              (previous, current) =>
                  previous.backgroundImageUrl != current.backgroundImageUrl,
          builder: (context, state) {
            return _shouldShowBackground(state)
                ? CachedNetworkImage(
                  imageUrl: state.backgroundImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox.shrink(),
                  errorWidget:
                      (context, error, stackTrace) => const SizedBox.shrink(),
                )
                : const SizedBox.shrink();
          },
        ),

        BlocBuilder<HomeCubit, HomeState>(
          buildWhen:
              (previous, current) =>
                  previous.backgroundImageUrl != current.backgroundImageUrl,
          builder: (context, state) {
            return _shouldShowBackground(state)
                ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
        SafeArea(child: child),
      ],
    );
  }

  bool _shouldShowBackground(HomeState state) {
    return !StringUtils.isNullOrEmpty(state.backgroundImageUrl) &&
        UrlUtils.isValid(state.backgroundImageUrl!);
  }
}
