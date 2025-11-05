import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
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
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      content: Text(
        I18n.of(context).profileLoggedInLogoutConfirmMessage,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      titleTextStyle: AppTextStyles.defaultTextStyle(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
      contentTextStyle: AppTextStyles.defaultTextStyle(
        context,
      ).copyWith(color: Theme.of(context).colorScheme.onSurface),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            I18n.of(context).profileLoggedInLogoutConfirmCancelButton,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
        TextButton(
          onPressed: () {
            onLogout();
            Navigator.of(context).pop();
          },
          child: Text(
            I18n.of(context).profileLoggedInLogoutConfirmLogoutButton,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
