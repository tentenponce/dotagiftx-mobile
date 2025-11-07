import 'package:dotagiftx_mobile/presentation/home/subviews/home_app_bar.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: Text(I18n.of(context).profileLoadingTitle)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
