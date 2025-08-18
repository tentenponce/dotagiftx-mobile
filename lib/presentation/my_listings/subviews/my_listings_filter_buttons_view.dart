import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_listings_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListingsFilterButtonsView extends StatelessWidget {
  const MyListingsFilterButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        children: [
          BlocBuilder<MyListingsCubit, MyListingsState>(
            buildWhen:
                (previous, current) =>
                    previous.marketSummary != current.marketSummary ||
                    previous.status != current.status,
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
            buildWhen:
                (previous, current) =>
                    previous.marketSummary != current.marketSummary ||
                    previous.status != current.status,
            builder: (context, state) {
              return MarketFilterButtonView(
                label: I18n.of(context).myListingsReservedButton(
                  state.marketSummary?.reservedListings ?? 0,
                ),
                filter: ApiConstants.queryMarketStatusReserved.toString(),
                currentFilter: state.status.toString(),
                onTap: () {
                  context.read<MyListingsCubit>().filterBy(
                    ApiConstants.queryMarketStatusReserved,
                  );
                },
              );
            },
          ),
          BlocBuilder<MyListingsCubit, MyListingsState>(
            buildWhen:
                (previous, current) =>
                    previous.marketSummary != current.marketSummary ||
                    previous.status != current.status,
            builder: (context, state) {
              return MarketFilterButtonView(
                label: I18n.of(context).myListingsDeliveredButton(
                  state.marketSummary?.deliveredListings ?? 0,
                ),
                filter: ApiConstants.queryMarketStatusSold.toString(),
                currentFilter: state.status.toString(),
                onTap: () {
                  context.read<MyListingsCubit>().filterBy(
                    ApiConstants.queryMarketStatusSold,
                  );
                },
              );
            },
          ),
          BlocBuilder<MyListingsCubit, MyListingsState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return MarketFilterButtonView(
                label: I18n.of(context).myListingsHistoryButton,
                filter: ApiConstants.queryMarketStatusAll.toString(),
                currentFilter: state.status.toString(),
                onTap: () {
                  context.read<MyListingsCubit>().filterBy(
                    ApiConstants.queryMarketStatusAll,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
