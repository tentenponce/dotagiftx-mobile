import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

mixin ViewCubitMixin<TCubit extends BaseCubit<dynamic>>
    implements CubitView<TCubit> {
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return _CubitProvider<TCubit>(
      create: () => onCreateCubit(context),
      child: buildView,
    );
  }

  @protected
  @override
  @mustCallSuper
  TCubit onCreateCubit(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final cubit = GetIt.instance<TCubit>();

    cubit.arguments = arguments;

    return cubit;
  }
}

class _CubitProvider<TCubit extends BaseCubit<dynamic>> extends StatefulWidget {
  final TCubit Function() create;

  final Widget Function(BuildContext) child;
  const _CubitProvider({required this.create, required this.child, super.key});

  @override
  State<StatefulWidget> createState() => _CubitProviderState<TCubit>();
}

class _CubitProviderState<TCubit extends BaseCubit<dynamic>>
    extends State<_CubitProvider<TCubit>> {
  late final TCubit _currentCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _currentCubit,
      child: widget.child(context),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentCubit = widget.create();
  }
}
