import 'package:dotagiftx_mobile/core/platform/app_navigation_observer/app_navigation_observer.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/dota_item_detail_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/offer_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketListingFilterButtonsView extends StatelessWidget {
  final AppNavigationObserver appNavigationObserver;
  const MarketListingFilterButtonsView({
    required this.appNavigationObserver,
    super.key,
  });

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
        return Wrap(
          spacing: 8,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterHighestPrice,
              filter: ApiConstants.querySortHighest,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortHighest,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'buy-orders-filter-highest-price',
                  screenClass: 'buy-orders-filter-highest-price',
                );
              },
            ),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterRecent,
              filter: ApiConstants.querySortRecent,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortRecent,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'buy-orders-filter-recent',
                  screenClass: 'buy-orders-filter-recent',
                );
              },
            ),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterTopBuyers,
              filter: ApiConstants.querySortBest,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().buyOrdersListCubit.sortBy(
                  ApiConstants.querySortBest,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'buy-orders-filter-best',
                  screenClass: 'buy-orders-filter-best',
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
              filter: ApiConstants.querySortLowest,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortLowest,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'offers-filter-lowest-price',
                  screenClass: 'offers-filter-lowest-price',
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterRecent,
              filter: ApiConstants.querySortRecent,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortRecent,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'offers-filter-recent',
                  screenClass: 'offers-filter-recent',
                );
              },
            ),
            const SizedBox(width: 8),
            MarketFilterButtonView(
              label: I18n.of(context).marketListingFilterTopSellers,
              filter: ApiConstants.querySortBest,
              currentFilter: state.sort,
              onTap: () {
                context.read<DotaItemDetailCubit>().offersListCubit.sortBy(
                  ApiConstants.querySortBest,
                );

                appNavigationObserver.logNavigation(
                  screenName: 'offers-filter-best',
                  screenClass: 'offers-filter-best',
                );
              },
            ),
          ],
        );
      },
    );
  }
}
