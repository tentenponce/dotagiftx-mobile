import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class GenericErrorDialog extends BasePageStatelessWidget {
  const GenericErrorDialog({super.key})
    : super(pageName: PageName.genericErrorDialog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        I18n.of(context).genericErrorDialogTitle,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        I18n.of(context).genericErrorDialogContent,
        style: AppTextStyles.defaultTextStyle(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
            I18n.of(context).genericErrorDialogOk,
            style: AppTextStyles.defaultTextStyle(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
