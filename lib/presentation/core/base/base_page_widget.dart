import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

abstract class BasePageWidget extends StatelessWidget {
  final PageName pageName;
  const BasePageWidget({required this.pageName, super.key});
}
