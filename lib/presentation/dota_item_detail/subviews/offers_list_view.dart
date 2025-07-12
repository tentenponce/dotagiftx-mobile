import 'dart:math';

import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/offer_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/market_offer_card_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/shimmer_market_listing_card_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersListView extends StatefulWidget {
  const OffersListView({super.key});

  @override
  State<OffersListView> createState() => _OffersListViewState();
}

class _OffersListViewState extends State<OffersListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OffersListCubit, OffersListState>(
      bloc: context.read<DotaItemDetailCubit>().offersListCubit,
      builder: (context, state) {
        // Loading state with shimmer
        if (state.isLoading) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                5, // Show 5 shimmer cards
                (index) => const ShimmerMarketListingCardView(),
              ),
            ),
          );
        }

        if (state.offers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                const Icon(
                  Icons.inbox_outlined,
                  color: AppColors.grey,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  I18n.of(context).offersEmpty,
                  style: const TextStyle(color: AppColors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Calculate total items: offers + loading more shimmer items + bottom padding
        final remainingOffers = state.totalOffersCount - state.offers.length;
        final maxShimmerItems =
            state.isLoadingMore ? min(remainingOffers, 10) : 0;
        final itemCount =
            state.offers.length + maxShimmerItems + 1; // +1 for bottom padding

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Offers
            if (index < state.offers.length) {
              final offer = state.offers[index];
              return MarketOfferCardView(offer: offer);
            }

            // Check if this is a loading more shimmer item
            if (state.isLoadingMore && index >= state.offers.length) {
              final shimmerIndex = index - state.offers.length;
              if (shimmerIndex < maxShimmerItems) {
                return const ShimmerMarketListingCardView();
              }
            }

            // Bottom padding (last item)
            return const SizedBox(height: 32);
          },
        );
      },
    );
  }
}
