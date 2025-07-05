import 'package:dotagiftx_mobile/presentation/core/base/state_base.dart';
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
  final void Function(String)? onTreasureTap;

  const TreasuresNavView({this.onTreasureTap, super.key});

  @override
  State<TreasuresNavView> createState() => _TreasuresNavViewState();
}

class _TreasuresNavViewState extends StateBase<TreasuresNavView> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  bool _isScrolled = false;
  bool _showClearButton = false;

  @override
  Widget build(BuildContext context) {
    final treasuresCubit = context.read<HomeCubit>().treasuresCubit;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: BlocBuilder<TreasuresCubit, TreasuresState>(
          bloc: treasuresCubit,
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
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.black,
      ),
      body: Column(
        children: [
          // Search Field
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: I18n.of(context).treasuresSearchHint,
                hintStyle: const TextStyle(color: AppColors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon:
                    _showClearButton
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showClearButton = false;
                            });
                            treasuresCubit.searchTreasure('');
                          },
                        )
                        : null,
                filled: true,
                fillColor: AppColors.darkGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _showClearButton = value.isNotEmpty;
                });
                treasuresCubit.searchTreasure(value);
              },
            ),
          ),
          // Main content
          Expanded(
            child: BlocBuilder<TreasuresCubit, TreasuresState>(
              bloc: treasuresCubit,
              buildWhen:
                  (previous, current) =>
                      previous.treasures != current.treasures ||
                      previous.loadingTreasures != current.loadingTreasures,
              builder: (context, state) {
                final treasures = state.treasures;
                final itemCount =
                    state.loadingTreasures ? 10 : treasures.length;

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async => treasuresCubit.onSwipeToRefresh(),
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                          return TreasureCard(
                            treasure: treasure,
                            onTap:
                                () => widget.onTreasureTap?.call(
                                  treasure.name ?? '',
                                ),
                          );
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);

    // set search query to the controller as the state is persisting as well
    _searchController.text =
        context.read<HomeCubit>().treasuresCubit.searchQuery;
    _showClearButton = _searchController.text.isNotEmpty;
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
