import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_page_stateless_widget.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/navigator_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/market_filter_button_view.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/unknown_history_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_orders_state.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/completed_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/my_active_order_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/my_order_dialog_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/order_removed_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/shimmer_order_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/subviews/to_receive_item_view.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/viewmodels/my_orders_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrdersView extends BasePageStatelessWidget
    with ViewCubitMixin<MyOrdersCubit> {
  const MyOrdersView({super.key}) : super(pageName: PageName.myOrders);

  @override
  Widget buildView(BuildContext context) {
    return const _MyOrdersViewContent();
  }
}

class _MyOrdersViewContent extends StatefulWidget {
  const _MyOrdersViewContent();

  @override
  State<_MyOrdersViewContent> createState() => _MyOrdersViewContentState();
}

class _MyOrdersViewContentState extends State<_MyOrdersViewContent> {
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
          I18n.of(context).myOrdersTitle,
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
              child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
                buildWhen:
                    (previous, current) => previous.status != current.status,
                builder: (context, state) {
                  final isDisabled =
                      state.status == ApiConstants.queryMarketStatusReserved;

                  return TextField(
                    enabled: !isDisabled,
                    controller: _searchController,
                    style: TextStyle(
                      color:
                          isDisabled
                              ? AppColors.grey.withValues(alpha: 0.5)
                              : Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: I18n.of(context).myOrdersSearchHint,
                      hintStyle: TextStyle(
                        color:
                            isDisabled
                                ? AppColors.grey.withValues(alpha: 0.3)
                                : AppColors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            isDisabled
                                ? AppColors.grey.withValues(alpha: 0.3)
                                : AppColors.grey,
                      ),
                      suffixIcon:
                          _showClearButton && !isDisabled
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
                                    context.read<MyOrdersCubit>().searchOrders(
                                      '',
                                    ),
                                  );
                                },
                              )
                              : null,
                      filled: true,
                      fillColor:
                          isDisabled
                              ? AppColors.darkGrey.withValues(alpha: 0.5)
                              : AppColors.darkGrey,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
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
                        context.read<MyOrdersCubit>().searchOrders(value),
                      );
                    },
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                children: [
                  BlocBuilder<MyOrdersCubit, MyOrdersState>(
                    buildWhen:
                        (previous, current) =>
                            previous.status != current.status,
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myOrdersActiveButton,
                        filter: ApiConstants.queryMarketStatusLive.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyOrdersCubit>().filterBy(
                            ApiConstants.queryMarketStatusLive,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<MyOrdersCubit, MyOrdersState>(
                    buildWhen:
                        (previous, current) =>
                            previous.marketSummary != current.marketSummary ||
                            previous.status != current.status,
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myOrdersToReceiveButton(
                          state.marketSummary?.toReceiveOrders ?? 0,
                        ),
                        filter:
                            ApiConstants.queryMarketStatusReserved.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyOrdersCubit>().filterBy(
                            ApiConstants.queryMarketStatusReserved,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<MyOrdersCubit, MyOrdersState>(
                    buildWhen:
                        (previous, current) =>
                            previous.marketSummary != current.marketSummary ||
                            previous.status != current.status,
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myOrdersCompletedButton(
                          state.marketSummary?.completedOrders ?? 0,
                        ),
                        filter:
                            ApiConstants.queryMarketStatusCompleted.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyOrdersCubit>().filterBy(
                            ApiConstants.queryMarketStatusCompleted,
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<MyOrdersCubit, MyOrdersState>(
                    buildWhen:
                        (previous, current) =>
                            previous.status != current.status,
                    builder: (context, state) {
                      return MarketFilterButtonView(
                        label: I18n.of(context).myOrdersHistoryButton,
                        filter: ApiConstants.queryMarketStatusAll.toString(),
                        currentFilter: state.status.toString(),
                        onTap: () {
                          context.read<MyOrdersCubit>().filterBy(
                            ApiConstants.queryMarketStatusAll,
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
                      await context.read<MyOrdersCubit>().refreshOrders();
                    },
                    child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
                      builder: _buildBody,
                    ),
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

  Widget _buildBody(BuildContext context, MyOrdersState state) {
    if (state.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              5, // Show 5 shimmer cards
              (index) => const ShimmerOrderItemView(),
            ),
          ),
        ),
      );
    }

    if (state.orders.isEmpty && !state.isLoading) {
      final searchQuery = context.read<MyOrdersCubit>().searchQuery;
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          ? I18n.of(context).myOrdersNoSearchActiveOrdersTitle
                          : I18n.of(context).myOrdersNoActiveOrders,
                      style: const TextStyle(
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
                          ).myOrdersNoSearchActiveOrdersDescription
                          : I18n.of(context).myOrdersNoActiveOrdersDescription,
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

    // Calculate total items: orders + loading more shimmer items + bottom padding
    final remainingOrders = state.totalOrdersCount - state.orders.length;
    final maxShimmerItems = state.isLoadingMore ? min(remainingOrders, 10) : 0;
    final itemCount =
        state.orders.length + maxShimmerItems + 1; // +1 for bottom padding

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Orders
        if (index < state.orders.length) {
          final order = state.orders[index];

          if (state.status == ApiConstants.queryMarketStatusLive) {
            return MyActiveOrderItemView(
              order: order,
              onTap: () => unawaited(_showActiveOrderDialog(context, order)),
            );
          } else if (state.status == ApiConstants.queryMarketStatusReserved) {
            return ToReceiveItemView(listing: order);
          } else if (state.status == ApiConstants.queryMarketStatusCompleted) {
            return CompletedItemView(listing: order);
          } else if (state.status == ApiConstants.queryMarketStatusAll) {
            switch (order.status) {
              case ApiConstants.queryMarketStatusLive:
                return MyActiveOrderItemView(
                  order: order,
                  onTap:
                      () => unawaited(_showActiveOrderDialog(context, order)),
                );
              case ApiConstants.queryMarketStatusReserved:
                return ToReceiveItemView(listing: order);
              case ApiConstants.queryMarketStatusCompleted:
                return CompletedItemView(listing: order);
              case ApiConstants.queryMarketStatusOrderRemoved:
                return OrderRemovedItemView(listing: order);
              default:
                return UnknownHistoryItemView(listing: order);
            }
          }
        }

        // Check if this is a loading more shimmer item
        if (state.isLoadingMore && index >= state.orders.length) {
          final shimmerIndex = index - state.orders.length;
          if (shimmerIndex < maxShimmerItems) {
            return const ShimmerOrderItemView();
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
      unawaited(context.read<MyOrdersCubit>().loadMoreOrders());
    }
  }

  Future<void> _showActiveOrderDialog(
    BuildContext context,
    MarketListingModel listing,
  ) async {
    final result = await NavigatorUtils.showPageModalBottomSheet<bool>(
      context,
      MyOrderDialogView(listing: listing),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if ((result ?? false) && context.mounted) {
      unawaited(context.read<MyOrdersCubit>().refreshOrders());
    }
  }
}
