import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:dotagiftx_mobile/presentation/profile/subviews/profile_loading_view.dart';
import 'package:dotagiftx_mobile/presentation/profile/subviews/profile_logged_in_view.dart';
import 'package:dotagiftx_mobile/presentation/profile/subviews/profile_not_login_view.dart';
import 'package:dotagiftx_mobile/presentation/profile/viewmodels/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends BasePageStatelessWidget
    with ViewCubitMixin<ProfileCubit> {
  final VoidCallback? loginSuccess;
  final VoidCallback? logoutSuccess;
  final bool? showBackButton;
  const ProfileView({
    this.loginSuccess,
    this.logoutSuccess,
    this.showBackButton = true,
    super.key,
  }) : super(pageName: PageName.profile);

  @override
  Widget buildView(BuildContext context) {
    return _ProfileView(
      loginSuccess: loginSuccess,
      logoutSuccess: logoutSuccess,
      showBackButton: showBackButton,
    );
  }
}

class _ProfileView extends StatefulWidget {
  final VoidCallback? loginSuccess;
  final VoidCallback? logoutSuccess;
  final bool? showBackButton;
  const _ProfileView({
    required this.loginSuccess,
    required this.logoutSuccess,
    required this.showBackButton,
  });

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: context.read<ProfileCubit>(),
      buildWhen:
          (previous, current) =>
              previous.user != current.user ||
              previous.isLoadingUser != current.isLoadingUser,
      builder: (context, state) {
        if (state.isLoadingUser) {
          return const ProfileLoadingView();
        }
        if (state.user != null) {
          return ProfileLoggedInView(user: state.user!);
        }
        return ProfileNotLoginView(showBackButton: widget.showBackButton);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().loginSuccess = widget.loginSuccess ?? () {};
    context.read<ProfileCubit>().logoutSuccess = widget.logoutSuccess ?? () {};
  }
}
