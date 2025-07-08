import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/dota_item_detail_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/offer_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketListingFilterButtonsView extends StatelessWidget {
  const MarketListingFilterButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DotaItemDetailCubit, DotaItemDetailState>(
      buildWhen: (previous, current) => previous.tab != current.tab,
      bloc: context.read<DotaItemDetailCubit>(),
      builder: (context, state) {
        switch (state.tab) {
          case MarketTab.offers:
            return _buildOffersFilterButtons(context);
          case MarketTab.buyOrders:
            return _buildBuyOrdersFilterButtons(context);
        }
      },
    );
  }

  Widget _buildBuyOrdersFilterButtons(BuildContext context) {
    return BlocBuilder<BuyOrdersListCubit, BuyOrdersListState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      bloc: context.read<DotaItemDetailCubit>().buyOrdersListCubit,
      builder: (context, state) {
        return Row(
          children: [
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterHighestPrice,
              sort: ApiConstants.querySortHighest,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortHighest,
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterRecent,
              sort: ApiConstants.querySortRecent,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortRecent,
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterTopBuyers,
              sort: ApiConstants.querySortBest,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortBest,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOffersFilterButtons(BuildContext context) {
    return BlocBuilder<OffersListCubit, OffersListState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      bloc: context.read<DotaItemDetailCubit>().offersListCubit,
      builder: (context, state) {
        return Row(
          children: [
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterLowestPrice,
              sort: ApiConstants.querySortLowest,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortLowest,
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterRecent,
              sort: ApiConstants.querySortRecent,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortRecent,
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterTopSellers,
              sort: ApiConstants.querySortBest,
              currentSort: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortBest,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
