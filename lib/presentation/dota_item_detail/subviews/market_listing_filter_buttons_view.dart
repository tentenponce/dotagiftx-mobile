import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/offer_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketListingFilterButtonsView extends StatelessWidget {
  const MarketListingFilterButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _offerFilterButton(
          context: context,
          label: I18n.of(context).marketListingFilterLowestPrice,
          sort: ApiConstants.querySortLowest,
        ),
        const SizedBox(width: 8),
        _offerFilterButton(
          context: context,
          label: I18n.of(context).marketListingFilterRecent,
          sort: ApiConstants.querySortRecent,
        ),
        const SizedBox(width: 8),
        _offerFilterButton(
          context: context,
          label: I18n.of(context).marketListingFilterTopSellers,
          sort: ApiConstants.querySortBest,
        ),
      ],
    );
  }

  Widget _offerFilterButton({
    required BuildContext context,
    required String label,
    required String sort,
  }) {
    return BlocBuilder<OffersListCubit, OffersListState>(
      buildWhen: (previous, current) => previous.sort != current.sort,
      bloc: context.read<DotaItemDetailCubit>().offersListCubit,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<DotaItemDetailCubit>().offersListCubit.sortBy(sort);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                state.sort == sort
                    ? const Color.fromARGB(255, 214, 214, 214)
                    : Colors.transparent,
            foregroundColor:
                state.sort == sort
                    ? Colors.black
                    : const Color.fromARGB(255, 214, 214, 214),
            side: const BorderSide(
              color: Color.fromRGBO(81, 81, 81, 1),
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
