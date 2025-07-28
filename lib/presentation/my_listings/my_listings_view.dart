import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_active_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/reserved_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/shimmer_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_listings_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListingsView extends StatelessWidget
    with ViewCubitMixin<MyListingsCubit> {
  const MyListingsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return const _MyListingsViewContent();
  }
}

class _MyListingsViewContent extends StatefulWidget {
  const _MyListingsViewContent();

  @override
  State<_MyListingsViewContent> createState() => _MyListingsViewContentState();
}

class _MyListingsViewContentState extends State<_MyListingsViewContent> {
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          I18n.of(context).myListingsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.black,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.black,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Search Field
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: I18n.of(context).myListingsSearchHint,
                  hintStyle: const TextStyle(color: AppColors.grey),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  suffixIcon:
                      _showClearButton
                          ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _showClearButton = false;
                              });
                              unawaited(
                                context.read<MyListingsCubit>().searchListings(
                                  '',
                                ),
                              );
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
                  unawaited(
                    context.read<MyListingsCubit>().searchListings(value),
                  );
                },
              ),
            ),

            // Filter Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                children: [
                  BlocBuilder<MyListingsCubit, MyListingsState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myListingsActiveButton,
                        filter: ApiConstants.queryMarketStatusLive.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyListingsCubit>().filterBy(
                            ApiConstants.queryMarketStatusLive,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<MyListingsCubit, MyListingsState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myListingsReservedButton,
                        filter:
                            ApiConstants.queryMarketStatusReserved.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyListingsCubit>().filterBy(
                            ApiConstants.queryMarketStatusReserved,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      await context.read<MyListingsCubit>().refreshListings();
                    },
                    child: BlocBuilder<MyListingsCubit, MyListingsState>(
                      builder: _buildBody,
                    ),
                  ),
                  // Top scroll shadow
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
              ),
            ),
          ],
        ),
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
  }

  Widget _buildBody(BuildContext context, MyListingsState state) {
    if (state.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              5, // Show 5 shimmer cards
              (index) => const ShimmerListingItemView(),
            ),
          ),
        ),
      );
    }

    if (state.listings.isEmpty && !state.isLoading) {
      final searchQuery = context.read<MyListingsCubit>().searchQuery;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              state.status == ApiConstants.queryMarketStatusLive
                  ? !StringUtils.isNullOrEmpty(searchQuery)
                      ? I18n.of(context).myListingsNoSearchActiveListingsTitle
                      : I18n.of(context).myListingsNoActiveListings
                  : !StringUtils.isNullOrEmpty(searchQuery)
                  ? I18n.of(context).myListingsNoSearchReservedListingsTitle
                  : I18n.of(context).myListingsNoReservedListings,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.status == ApiConstants.queryMarketStatusLive
                  ? !StringUtils.isNullOrEmpty(searchQuery)
                      ? I18n.of(
                        context,
                      ).myListingsNoSearchActiveListingsDescription
                      : I18n.of(context).myListingsNoActiveListingsDescription
                  : !StringUtils.isNullOrEmpty(searchQuery)
                  ? I18n.of(
                    context,
                  ).myListingsNoSearchReservedListingsDescription
                  : I18n.of(context).myListingsNoReservedListingsDescription,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculate total items: listing + loading more shimmer items + bottom padding
    final remainingListings = state.totalListingsCount - state.listings.length;
    final maxShimmerItems =
        state.isLoadingMore ? min(remainingListings, 10) : 0;
    final itemCount =
        state.listings.length + maxShimmerItems + 1; // +1 for bottom padding

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Listings
        if (index < state.listings.length) {
          final listing = state.listings[index];

          if (state.status == ApiConstants.queryMarketStatusLive) {
            return MyActiveListingItemView(listing: listing);
          } else {
            return ReservedItemView(listing: listing);
          }
        }

        // Check if this is a loading more shimmer item
        if (state.isLoadingMore && index >= state.listings.length) {
          final shimmerIndex = index - state.listings.length;
          if (shimmerIndex < maxShimmerItems) {
            return const ShimmerListingItemView();
          }
        }

        // Bottom padding (last item)
        return const SizedBox(height: 32);
      },
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

    if (_scrollController.hasClients &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent - 200) {
      unawaited(context.read<MyListingsCubit>().loadMoreListings());
    }
  }
}
