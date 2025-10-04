import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/state_base.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_elevated_button.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_outline_button.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/states/profile_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/dota_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/search_catalog_textfield_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/search_results_list_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/shimmer_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/profile_cubit.dart';
import 'package:dotagiftx_mobile/presentation/post_item/post_item_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavView extends StatefulWidget {
  const HomeNavView({super.key});

  @override
  State<HomeNavView> createState() => _HomeNavViewState();
}

abstract class HomeSectionEntry {}

class ItemEntry extends HomeSectionEntry {
  final DotaItemModel item;
  ItemEntry(this.item);
}

class SectionHeaderEntry extends HomeSectionEntry {
  final String title;
  SectionHeaderEntry(this.title);
}

class ShimmerEntry extends HomeSectionEntry {}

class _HomeNavViewState extends StateBase<HomeNavView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final Map<String, int> sectionIndexMap = {};
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = colorScheme.surface;
    final fgColor = colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          I18n.of(context).homeHome,
          style: AppTextStyles.defaultTextStyle(context),
        ),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        scrolledUnderElevation: 0,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            bloc: context.read<HomeCubit>().profileCubit,
            buildWhen: (previous, current) => previous.user != current.user,
            builder: (context, state) {
              return state.user != null
                  ? AppOutlineButton(
                    onPressed: () {
                      unawaited(
                        NavigatorUtils.push(context, const PostItemView()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      I18n.of(context).homeNavPostItemButton,
                      style: AppTextStyles.defaultTextStyle(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          SearchCatalogTextfieldView(controller: _searchController),

          // Main content
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.searchResults.isNotEmpty ||
                    !StringUtils.isNullOrEmpty(state.currentSearchQuery) ||
                    state.loadingSearchResults) {
                  return SearchResultsListView(
                    searchResults: state.searchResults,
                    onRefresh:
                        () async => context.read<HomeCubit>().searchCatalog(
                          query: _searchController.text,
                        ),
                    isLoading: state.loadingSearchResults,
                    totalSearchResultsCount: state.totalSearchResultsCount,
                    loadingMoreResults: state.loadingMoreSearchResults,
                  );
                }

                // Combine all sections into a flat list
                final sectionEntries = <HomeSectionEntry>[];
                var currentIndex = 0;

                void addSection(
                  String title,
                  Iterable<DotaItemModel> items, {
                  required bool isLoading,
                }) {
                  sectionIndexMap[title] = currentIndex;
                  sectionEntries.add(SectionHeaderEntry(title));
                  currentIndex++;

                  if (isLoading) {
                    // Add shimmer items when loading
                    for (var i = 0; i < 5; i++) {
                      sectionEntries.add(ShimmerEntry());
                      currentIndex++;
                    }
                  } else {
                    // Add actual items
                    for (final item in items) {
                      sectionEntries.add(ItemEntry(item));
                      currentIndex++;
                    }
                  }
                }

                addSection(
                  I18n.of(context).homeTrending,
                  state.trendingItems,
                  isLoading: state.loadingTrendingItems,
                );
                addSection(
                  I18n.of(context).homeNewBuyOrders,
                  state.newBuyOrderItems,
                  isLoading: state.loadingNewBuyOrderItems,
                );
                addSection(
                  I18n.of(context).homeNewSellListings,
                  state.newSellListingItems,
                  isLoading: state.loadingNewSellListingItems,
                );

                return Column(
                  children: [
                    // Navigation Buttons
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppElevatedButton(
                              width: double.infinity,
                              onPressed:
                                  () => _scrollToSection(
                                    I18n.of(context).homeNewBuyOrders,
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.surfaceContainer,
                                foregroundColor: colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                I18n.of(context).homeNewBuyOrders,
                                style: AppTextStyles.defaultTextStyle(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppElevatedButton(
                              width: double.infinity,
                              onPressed:
                                  () => _scrollToSection(
                                    I18n.of(context).homeNewSellListings,
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.surfaceContainer,
                                foregroundColor: colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                I18n.of(context).homeNewSellListings,
                                style: AppTextStyles.defaultTextStyle(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lazy-loaded main content with scroll shadow
                    Expanded(
                      child: Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh:
                                () async => context.read<HomeCubit>().init(),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: sectionEntries.length,
                              itemBuilder: (context, index) {
                                final entry = sectionEntries[index];
                                if (entry is SectionHeaderEntry) {
                                  return _buildSectionHeader(entry.title);
                                } else if (entry is ItemEntry) {
                                  return DotaItemCardView(item: entry.item);
                                } else if (entry is ShimmerEntry) {
                                  return const ShimmerItemCardView();
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          // Top scroll shadow
                          AnimatedOpacity(
                            opacity: _isScrolled ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            child: Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.black.withValues(alpha: 0.2),
                                      AppColors.black.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _searchController.text = context.read<HomeCubit>().state.currentSearchQuery;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: AppTextStyles.defaultTextStyle(
          context,
        ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
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

  void _scrollToSection(String sectionTitle) {
    final index = sectionIndexMap[sectionTitle];
    if (index == null) {
      return;
    }

    /// trending item card view approx height
    /// for simplicity instead of calculating the actual height
    /// which may cause performance issues
    const itemHeight = 90.0;
    unawaited(
      _scrollController.animateTo(
        index * itemHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ),
    );
  }
}
