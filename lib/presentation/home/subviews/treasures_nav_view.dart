import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/states/treasures_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/shimmer_treasure_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/treasure_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/treasures_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuresNavView extends StatefulWidget {
  const TreasuresNavView({super.key});

  @override
  State<TreasuresNavView> createState() => _TreasuresNavViewState();
}

class _TreasuresNavViewState extends State<TreasuresNavView>
    with ViewCubitMixin<TreasuresCubit> {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: BlocBuilder<TreasuresCubit, TreasuresState>(
          bloc: context.read<HomeCubit>().treasuresCubit,
          buildWhen:
              (previous, current) =>
                  previous.treasures.length != current.treasures.length,
          builder: (context, state) {
            return Text(
              I18n.of(context).homeNavTreasures(state.treasures.length),
            );
          },
        ),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<TreasuresCubit, TreasuresState>(
        bloc: context.read<HomeCubit>().treasuresCubit,
        buildWhen:
            (previous, current) =>
                previous.treasures != current.treasures ||
                previous.loadingTreasures != current.loadingTreasures,
        builder: (context, state) {
          final treasures = state.treasures.toList();
          final itemCount = state.loadingTreasures ? 10 : treasures.length;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh:
                    () async =>
                        context
                            .read<HomeCubit>()
                            .treasuresCubit
                            .onSwipeToRefresh(),
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (state.loadingTreasures) {
                      return const ShimmerTreasureCardView();
                    }

                    final treasure = treasures[index];
                    return TreasureCard(treasure: treasure);
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
    FocusScope.of(context).unfocus();

    final isScrolled =
        _scrollController.hasClients && _scrollController.offset > 0;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }
}
