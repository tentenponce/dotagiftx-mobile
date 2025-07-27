import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_listing_item_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(
          'My Listings',
          style: TextStyle(
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
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<MyListingsCubit>().refreshListings();
                },
                child: BlocBuilder<MyListingsCubit, MyListingsState>(
                  builder: _buildBody,
                ),
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildBody(BuildContext context, MyListingsState state) {
    if (state.isLoading && state.listings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            5, // Show 5 shimmer cards
            (index) => const ShimmerListingItemView(),
          ),
        ),
      );
    }

    if (state.listings.isEmpty && !state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: AppColors.grey),
            const SizedBox(height: 16),
            Text(
              state.status == ApiConstants.queryMarketStatusLive
                  ? I18n.of(context).myListingsNoActiveListings
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
                  ? I18n.of(context).myListingsNoActiveListingsDescription
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
        // Offers
        if (index < state.listings.length) {
          final offer = state.listings[index];
          return MyListingItemView(listing: offer);
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
    if (_scrollController.hasClients &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent - 200) {
      unawaited(context.read<MyListingsCubit>().loadMoreListings());
    }
  }
}
