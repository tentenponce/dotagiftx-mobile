import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends BasePageStatelessWidget {
  final VoidCallback onLogout;
  const LogoutDialog({required this.onLogout, super.key})
    : super(pageName: PageName.logoutConfirmDialog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        I18n.of(context).profileLoggedInLogoutConfirmTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        I18n.of(context).profileLoggedInLogoutConfirmMessage,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: AppColors.black,
      titleTextStyle: const TextStyle(color: Colors.white),
      contentTextStyle: const TextStyle(color: Colors.white),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            I18n.of(context).profileLoggedInLogoutConfirmCancelButton,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onLogout();
            Navigator.of(context).pop();
          },
          child: Text(
            I18n.of(context).profileLoggedInLogoutConfirmLogoutButton,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
