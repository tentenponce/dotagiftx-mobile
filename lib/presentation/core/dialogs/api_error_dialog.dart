import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class ApiErrorDialog extends BasePageStatelessWidget {
  final String? code;
  final String? message;

  const ApiErrorDialog({this.message, this.code, super.key})
    : super(pageName: PageName.apiErrorDialog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkGrey,
      title: Text(
        I18n.of(context).apiErrorDialogTitle,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      content: Text(
        '${StringUtils.isNullOrEmpty(message) ? '' : '$message '}(${StringUtils.isNullOrEmpty(code) ? '0' : code})',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            I18n.of(context).apiErrorDialogOk,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
