import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/unknown_history_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/cancelled_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/delivered_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/listing_removed_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_active_listing_dialog_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_active_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_listings_filter_buttons_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/reserved_item_dialog_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/reserved_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/shimmer_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/viewmodels/my_listings_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListingsView extends BasePageStatelessWidget
    with ViewCubitMixin<MyListingsCubit> {
  const MyListingsView({super.key}) : super(pageName: PageName.myListings);

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          I18n.of(context).myListingsTitle,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        scrolledUnderElevation: 0,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Search Field
            Container(
              padding: const EdgeInsets.all(16),
              child: AppTextField(
                controller: _searchController,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon:
                    _showClearButton
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.grey),
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
            const MyListingsFilterButtonsView(),

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
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      !StringUtils.isNullOrEmpty(searchQuery)
                          ? I18n.of(context).myListingsNoSearchListingsTitle
                          : I18n.of(context).myListingsNoActiveListings,
                      style: AppTextStyles.defaultTextStyle(context).copyWith(
                        color: AppColors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      !StringUtils.isNullOrEmpty(searchQuery)
                          ? I18n.of(
                            context,
                          ).myListingsNoSearchListingsDescription
                          : I18n.of(
                            context,
                          ).myListingsNoActiveListingsDescription,
                      style: AppTextStyles.defaultTextStyle(
                        context,
                      ).copyWith(color: AppColors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
            return MyActiveListingItemView(
              listing: listing,
              onTap:
                  () => unawaited(_showActiveListingDialog(context, listing)),
            );
          } else if (state.status == ApiConstants.queryMarketStatusReserved) {
            return ReservedItemView(
              listing: listing,
              onTap: () => unawaited(_showReservedItemDialog(context, listing)),
            );
          } else if (state.status == ApiConstants.queryMarketStatusSold) {
            return DeliveredItemView(listing: listing);
          } else if (state.status == ApiConstants.queryMarketStatusAll) {
            switch (listing.status) {
              case ApiConstants.queryMarketStatusLive:
                return MyActiveListingItemView(
                  listing: listing,
                  onTap:
                      () =>
                          unawaited(_showActiveListingDialog(context, listing)),
                );
              case ApiConstants.queryMarketStatusReserved:
                return ReservedItemView(
                  listing: listing,
                  onTap:
                      () =>
                          unawaited(_showReservedItemDialog(context, listing)),
                );
              case ApiConstants.queryMarketStatusSold:
                return DeliveredItemView(listing: listing);
              case ApiConstants.queryMarketStatusCancelled:
                return CancelledItemView(listing: listing);
              case ApiConstants.queryMarketStatusOrderRemoved:
                return ListingRemovedItemView(listing: listing);
              default:
                return UnknownHistoryItemView(listing: listing);
            }
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

  Future<void> _showActiveListingDialog(
    BuildContext context,
    MarketListingModel listing,
  ) async {
    final result = await NavigatorUtils.showPageModalBottomSheet<bool>(
      context,
      MyActiveListingDialogView(listing: listing),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if ((result ?? false) && context.mounted) {
      unawaited(context.read<MyListingsCubit>().refreshListings());
    }
  }

  Future<void> _showReservedItemDialog(
    BuildContext context,
    MarketListingModel listing,
  ) async {
    final result = await NavigatorUtils.showPageModalBottomSheet<bool>(
      context,
      ReservedItemDialogView(listing: listing),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if ((result ?? false) && context.mounted) {
      unawaited(context.read<MyListingsCubit>().refreshListings());
    }
  }
}
