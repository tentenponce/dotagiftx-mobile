import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/offer_card_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
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
    return BlocBuilder<DotaItemDetailCubit, OffersState>(
      builder: (context, state) {
        if (state.isLoading && state.offers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state.error != null && state.offers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.grey,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  style: const TextStyle(color: AppColors.grey, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<DotaItemDetailCubit>().loadOffers(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.offers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, color: AppColors.grey, size: 48),
                SizedBox(height: 16),
                Text(
                  'No offers available',
                  style: TextStyle(color: AppColors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Calculate total items: offers + loading indicator + bottom padding
        final itemCount =
            state.offers.length + // offers
            (state.isLoadingMore ? 1 : 0) + // loading indicator
            1; // bottom padding

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Offers
            if (index < state.offers.length) {
              final offer = state.offers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: OfferCardView(
                  offer: offer,
                  onTap: () {
                    // TODO: Handle offer tap
                    debugPrint('Tapped offer: ${offer.id}');
                  },
                ),
              );
            }

            // Loading more indicator
            if (state.isLoadingMore && index == state.offers.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            // Bottom padding (last item)
            return const SizedBox(height: 32);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Load initial offers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DotaItemDetailCubit>().loadOffers();
    });
  }
}
