import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/states/login_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/login_webview_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/login_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginNavView extends StatelessWidget {
  const LoginNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(I18n.of(context).loginNavLogin),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                I18n.of(context).loginNavDescription,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildFeatureText(I18n.of(context).loginNavFeature1),
              _buildFeatureText(I18n.of(context).loginNavFeature2),
              _buildFeatureText(I18n.of(context).loginNavFeature3),
              _buildFeatureText(I18n.of(context).loginNavFeature4),
              const SizedBox(height: 16),
              Text(
                I18n.of(context).loginNavNote,
                style: const TextStyle(color: AppColors.warningBlue),
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginCubit, LoginState>(
                bloc: context.read<HomeCubit>().loginCubit,
                builder: (context, state) {
                  return state.loadingLogin
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            unawaited(
                              _showWebviewBottomSheet(
                                context,
                                context
                                    .read<HomeCubit>()
                                    .loginCubit
                                    .getLoginUrl(),
                                I18n.of(context).loginWebviewTitle,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.dirtyWhite,
                            side: const BorderSide(color: AppColors.dirtyWhite),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Assets.images.steam.svg(
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColors.dirtyWhite,
                              BlendMode.srcIn,
                            ),
                          ),
                          label: Text(
                            I18n.of(context).loginNavSignInButton,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                },
              ),
              const SizedBox(height: 16),
              Text(
                I18n.of(context).loginNavSignInNote,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.warningYellow,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            I18n.of(context).loginNavHowToTitle,
                            style: const TextStyle(
                              color: AppColors.warningYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            I18n.of(context).loginNavHowToDescription,
                            style: const TextStyle(
                              color: AppColors.warningYellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureText(String text) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  Future<void> _showWebviewBottomSheet(
    BuildContext context,
    String url,
    String title,
  ) async {
    final query = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LoginWebviewView(url: url, title: title),
    );

    if (!StringUtils.isNullOrEmpty(query) && context.mounted) {
      unawaited(context.read<HomeCubit>().loginCubit.login(query!));
    }
  }
}
