import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:flutter/widgets.dart';

abstract interface class CubitView<TCubit extends BaseCubit<dynamic>> {
  Widget build(BuildContext context);

  Widget buildView(BuildContext context);

  TCubit onCreateCubit(BuildContext context);
}
