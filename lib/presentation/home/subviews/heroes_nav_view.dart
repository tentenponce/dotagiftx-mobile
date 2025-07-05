import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/states/heroes_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/hero_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/shimmer_hero_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/heroes_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeroesNavView extends StatefulWidget {
  const HeroesNavView({super.key});

  @override
  State<HeroesNavView> createState() => _HeroesNavViewState();
}

class _HeroesNavViewState extends State<HeroesNavView> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    final heroesCubit = context.read<HomeCubit>().heroesCubit;
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: BlocBuilder<HeroesCubit, HeroesState>(
          bloc: heroesCubit,
          builder: (context, state) {
            return Text(I18n.of(context).homeNavHeroes(state.heroes.length));
          },
        ),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<HeroesCubit, HeroesState>(
        bloc: heroesCubit,
        builder: (context, state) {
          final heroes = state.heroes;
          final itemCount = state.loadingHeroes ? 15 : heroes.length;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => heroesCubit.onSwipeToRefresh(),
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (state.loadingHeroes) {
                      return const ShimmerHeroCardView();
                    }

                    final hero = heroes[index];
                    return HeroCardView(hero: hero);
                  },
                ),
              ),
              // Top shadow when scrolled
              if (_isScrolled)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withValues(alpha: 0.8),
                          AppColors.black.withValues(alpha: 0.4),
                          AppColors.black.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isScrolled = _scrollController.offset > 0;
      if (isScrolled != _isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    }
  }
}
