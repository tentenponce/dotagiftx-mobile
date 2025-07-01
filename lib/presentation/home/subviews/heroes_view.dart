import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeroesView extends StatelessWidget {
  const HeroesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context).homeHeroes)),
      body: SingleChildScrollView(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return const Text('Heroes');
          },
        ),
      ),
    );
  }
}
