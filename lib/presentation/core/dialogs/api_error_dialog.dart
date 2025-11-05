import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        I18n.of(context).apiErrorDialogTitle,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontWeight: FontWeight.w600),
      ),
      content: Text(
        '${StringUtils.isNullOrEmpty(message) ? '' : '$message '}(${StringUtils.isNullOrEmpty(code) ? '0' : code})',
        style: AppTextStyles.defaultTextStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            I18n.of(context).apiErrorDialogOk,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
