import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/profile_logged_in_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/profile_not_login_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNavView extends StatelessWidget {
  const ProfileNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: context.read<HomeCubit>().profileCubit,
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        if (state.user != null) {
          return ProfileLoggedInView(user: state.user!);
        }
        return const ProfileNotLoginView();
      },
    );
  }
}
