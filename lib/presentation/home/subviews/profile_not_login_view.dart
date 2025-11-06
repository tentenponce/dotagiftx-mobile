import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_outline_button.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/home_app_bar.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/login_webview_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/profile_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNotLoginView extends StatelessWidget {
  const ProfileNotLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: HomeAppBar(
        title: Text(
          I18n.of(context).loginNavLogin,
          style: AppTextStyles.defaultTextStyle(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18n.of(context).loginNavDescription,
                  style: AppTextStyles.defaultTextStyle(context),
                ),
                const SizedBox(height: 16),
                _buildFeatureText(context, I18n.of(context).loginNavFeature1),
                _buildFeatureText(context, I18n.of(context).loginNavFeature2),
                _buildFeatureText(context, I18n.of(context).loginNavFeature3),
                _buildFeatureText(context, I18n.of(context).loginNavFeature4),
                const SizedBox(height: 16),
                Text(
                  I18n.of(context).loginNavNote,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(color: AppColors.warningBlue),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProfileCubit, ProfileState>(
                  bloc: context.read<HomeCubit>().profileCubit,
                  builder: (context, state) {
                    return state.loadingLogin
                        ? const Center(child: CircularProgressIndicator())
                        : AppOutlineButton(
                          width: double.infinity,
                          height: 72,
                          onPressed: () {
                            unawaited(
                              _showWebviewBottomSheet(
                                context,
                                context
                                    .read<HomeCubit>()
                                    .profileCubit
                                    .getLoginUrl(),
                                I18n.of(context).loginWebviewTitle,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.onSurface,
                            side: BorderSide(color: colorScheme.onSurface),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Assets.images.steam.svg(
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                          child: Text(
                            I18n.of(context).loginNavSignInButton,
                            style: AppTextStyles.defaultTextStyle(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  I18n.of(context).loginNavSignInNote,
                  style: AppTextStyles.defaultTextStyle(
                    context,
                  ).copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureText(BuildContext context, String text) {
    return Text(text, style: AppTextStyles.defaultTextStyle(context));
  }

  Future<void> _showWebviewBottomSheet(
    BuildContext context,
    String url,
    String title,
  ) async {
    final query = await NavigatorUtils.showPageModalBottomSheet<String>(
      context,
      LoginWebviewView(url: url, title: title),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (!StringUtils.isNullOrEmpty(query) && context.mounted) {
      unawaited(context.read<HomeCubit>().profileCubit.login(query!));
    }
  }
}
