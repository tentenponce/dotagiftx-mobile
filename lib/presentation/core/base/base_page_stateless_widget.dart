import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

abstract class BasePageStatelessWidget extends StatelessWidget with PageNamed {
  @override
  final PageName pageName;
  const BasePageStatelessWidget({required this.pageName, super.key});
}
