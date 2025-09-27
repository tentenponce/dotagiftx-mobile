import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

abstract class BasePageStatefulWidget extends StatefulWidget with PageNamed {
  @override
  final PageName pageName;
  const BasePageStatefulWidget({required this.pageName, super.key});
}
