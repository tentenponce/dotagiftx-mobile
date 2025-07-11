import 'dart:async';

import 'package:dotagiftx_mobile/presentation/core/base/state_base.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/heroes_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/home_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/treasures_nav_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/roadmap/roadmap_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget with ViewCubitMixin<HomeCubit> {
  const HomeView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends StateBase<_HomeView> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.darkGrey,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.grey,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: I18n.of(context).homeHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.diamond_rounded),
              label: I18n.of(context).homeTreasures,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.groups),
              label: I18n.of(context).homeHeroes,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: I18n.of(context).homeProfile,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeNavView(),
      TreasuresNavView(onTreasureTap: _navigateToHomeWithSearch),
      HeroesNavView(onHeroTap: _navigateToHomeWithSearch),
      const RoadmapView(),
    ];
  }

  void _navigateToHomeWithSearch(String searchQuery) {
    // Navigate to home tab
    setState(() {
      _currentIndex = 0;
    });

    // Set search query in HomeCubit
    unawaited(context.read<HomeCubit>().searchCatalog(query: searchQuery));
  }
}
