import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/login_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoginNavView extends StatelessWidget with ViewCubitMixin<LoginCubit> {
  const LoginNavView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(I18n.of(context).homeNavLogin),
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
                I18n.of(context).homeNavLoginDescription,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 16),
              _buildFeatureText(I18n.of(context).homeNavLoginFeature1),
              _buildFeatureText(I18n.of(context).homeNavLoginFeature2),
              _buildFeatureText(I18n.of(context).homeNavLoginFeature3),
              _buildFeatureText(I18n.of(context).homeNavLoginFeature4),
              const SizedBox(height: 16),
              Text(
                I18n.of(context).homeNavLoginNote,
                style: const TextStyle(color: AppColors.warningBlue),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
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
                    I18n.of(context).homeNavSignInButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                I18n.of(context).homeNavSignInNote,
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
                            I18n.of(context).homeNavHowToTitle,
                            style: const TextStyle(
                              color: AppColors.warningYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            I18n.of(context).homeNavHowToDescription,
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
}
