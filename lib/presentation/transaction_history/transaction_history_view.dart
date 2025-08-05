import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/my_active_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/reserved_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/subviews/shimmer_listing_item_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:dotagiftx_mobile/presentation/transaction_history/states/transaction_history_state.dart';
import 'package:dotagiftx_mobile/presentation/transaction_history/viewmodels/transaction_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistoryView extends StatelessWidget
    with ViewCubitMixin<TransactionHistoryCubit> {
  const TransactionHistoryView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return const _TransactionHistoryViewContent();
  }
}

class _TransactionHistoryViewContent extends StatefulWidget {
  const _TransactionHistoryViewContent();

  @override
  State<_TransactionHistoryViewContent> createState() =>
      _TransactionHistoryViewContentState();
}

class _TransactionHistoryViewContentState
    extends State<_TransactionHistoryViewContent> {
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
          I18n.of(context).transactionHistoryTitle,
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
                                context
                                    .read<TransactionHistoryCubit>()
                                    .searchTransactions(''),
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
                    context.read<TransactionHistoryCubit>().searchTransactions(
                      value,
                    ),
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
                  BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).transactionHistoryAllButton,
                        filter: TransactionHistoryFilter.all.toString(),
                        currentFilter: state.filter.toString(),
                        onTap: () {
                          context.read<TransactionHistoryCubit>().filterBy(
                            TransactionHistoryFilter.all,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label:
                            I18n.of(context).transactionHistoryDeliveredButton,
                        filter: TransactionHistoryFilter.delivered.toString(),
                        currentFilter: state.filter.toString(),
                        onTap: () {
                          context.read<TransactionHistoryCubit>().filterBy(
                            TransactionHistoryFilter.delivered,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label:
                            I18n.of(context).transactionHistoryToReceiveButton,
                        filter: TransactionHistoryFilter.toReceive.toString(),
                        currentFilter: state.filter.toString(),
                        onTap: () {
                          context.read<TransactionHistoryCubit>().filterBy(
                            TransactionHistoryFilter.toReceive,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label:
                            I18n.of(context).transactionHistoryCompletedButton,
                        filter: TransactionHistoryFilter.completed.toString(),
                        currentFilter: state.filter.toString(),
                        onTap: () {
                          context.read<TransactionHistoryCubit>().filterBy(
                            TransactionHistoryFilter.completed,
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
                      await context
                          .read<TransactionHistoryCubit>()
                          .refreshTransactions();
                    },
                    child: BlocBuilder<
                      TransactionHistoryCubit,
                      TransactionHistoryState
                    >(builder: _buildBody),
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

  Widget _buildBody(BuildContext context, TransactionHistoryState state) {
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

    if (state.transactions.isEmpty && !state.isLoading) {
      final searchQuery = context.read<TransactionHistoryCubit>().searchQuery;
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
                      state.filter == TransactionHistoryFilter.all
                          ? !StringUtils.isNullOrEmpty(searchQuery)
                              ? I18n.of(
                                context,
                              ).myListingsNoSearchActiveListingsTitle
                              : I18n.of(context).myListingsNoActiveListings
                          : !StringUtils.isNullOrEmpty(searchQuery)
                          ? I18n.of(
                            context,
                          ).myListingsNoSearchReservedListingsTitle
                          : I18n.of(context).myListingsNoReservedListings,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.filter == TransactionHistoryFilter.all
                          ? !StringUtils.isNullOrEmpty(searchQuery)
                              ? I18n.of(
                                context,
                              ).myListingsNoSearchActiveListingsDescription
                              : I18n.of(
                                context,
                              ).myListingsNoActiveListingsDescription
                          : !StringUtils.isNullOrEmpty(searchQuery)
                          ? I18n.of(
                            context,
                          ).myListingsNoSearchReservedListingsDescription
                          : I18n.of(
                            context,
                          ).myListingsNoReservedListingsDescription,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
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
    final remainingListings =
        state.totalTransactionsCount - state.transactions.length;
    final maxShimmerItems =
        state.isLoadingMore ? min(remainingListings, 10) : 0;
    final itemCount =
        state.transactions.length +
        maxShimmerItems +
        1; // +1 for bottom padding

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Listings
        if (index < state.transactions.length) {
          final listing = state.transactions[index];

          if (state.filter == TransactionHistoryFilter.all) {
            return MyActiveListingItemView(listing: listing);
          } else {
            return ReservedItemView(listing: listing);
          }
        }

        // Check if this is a loading more shimmer item
        if (state.isLoadingMore && index >= state.transactions.length) {
          final shimmerIndex = index - state.transactions.length;
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
      unawaited(context.read<TransactionHistoryCubit>().loadMoreTransactions());
    }
  }
}
