import 'dart:math';

import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/market_buy_order_card_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/shimmer_market_listing_card_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyOrdersListView extends StatefulWidget {
  const BuyOrdersListView({super.key});

  @override
  State<BuyOrdersListView> createState() => _BuyOrdersListViewState();
}

class _BuyOrdersListViewState extends State<BuyOrdersListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyOrdersListCubit, BuyOrdersListState>(
      bloc: context.read<DotaItemDetailCubit>().buyOrdersListCubit,
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

        if (state.buyOrders.isEmpty) {
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
                  I18n.of(context).buyOrdersEmpty,
                  style: const TextStyle(color: AppColors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Calculate total items: buy orders + loading more shimmer items + bottom padding
        final remainingBuyOrders =
            state.totalBuyOrdersCount - state.buyOrders.length;
        final maxShimmerItems =
            state.isLoadingMore ? min(remainingBuyOrders, 10) : 0;
        final itemCount =
            state.buyOrders.length +
            maxShimmerItems +
            1; // +1 for bottom padding

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Buy Orders
            if (index < state.buyOrders.length) {
              final buyOrder = state.buyOrders[index];
              return MarketBuyOrderCardView(
                buyOrder: buyOrder,
                onTap: () {
                  // TODO(tenten): Handle contact buyer
                  debugPrint('Contact buyer: ${buyOrder.user?.name}');
                },
              );
            }

            // Check if this is a loading more shimmer item
            if (state.isLoadingMore && index >= state.buyOrders.length) {
              final shimmerIndex = index - state.buyOrders.length;
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
