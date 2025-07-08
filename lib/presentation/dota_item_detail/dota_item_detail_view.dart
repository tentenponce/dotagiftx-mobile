import 'dart:async';

import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/measure_size_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/ofer_list_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/dota_item_market_detail_subview.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/offers_list_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DotaItemDetailView extends StatelessWidget
    with ViewCubitMixin<DotaItemDetailCubit> {
  final DotaItemModel item;
  const DotaItemDetailView({required this.item, super.key});

  @override
  Widget buildView(BuildContext context) {
    return _DotaItemDetailView(item: item);
  }
}

class _DotaItemDetailView extends StatefulWidget {
  final DotaItemModel item;

  const _DotaItemDetailView({required this.item});

  @override
  State<_DotaItemDetailView> createState() => _DotaItemDetailViewState();
}

class _DotaItemDetailViewState extends State<_DotaItemDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  double _contentHeight = 550; // Default fallback height
  bool _hasCalculatedHeight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Hidden measurement widget to adjust expanded height dynamically
          // and not let title overlap with the content
          Offstage(
            child: MeasureSizeView(
              onChange: (size) {
                if (!_hasCalculatedHeight) {
                  setState(() {
                    // add 120 to account for the title to not overlap with the content
                    _contentHeight = size.height + 120;
                    _hasCalculatedHeight = true;
                  });
                }
              },
              child: DotaItemMarketDetailSubview(item: widget.item),
            ),
          ),
          // Main content
          RefreshIndicator(
            onRefresh: () async {
              context.read<DotaItemDetailCubit>().onSwipeToRefresh();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Main collapsing header with item details
                SliverAppBar(
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                  scrolledUnderElevation: 0,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  expandedHeight: _contentHeight,
                  flexibleSpace: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      final minExtent =
                          kToolbarHeight + MediaQuery.of(context).padding.top;

                      final t = ((constraints.maxHeight - minExtent) /
                              (_contentHeight - minExtent))
                          .clamp(0.0, 1.0);

                      // Interpolated padding
                      const double startPadding = 64; // when collapsed
                      const double endPadding = 16; // when expanded
                      final interpolatedPadding =
                          startPadding * (1 - t) + endPadding * t;

                      return FlexibleSpaceBar(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.name ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        titlePadding: EdgeInsets.only(
                          left: interpolatedPadding,
                          bottom: 18,
                          right: 16,
                        ),
                        collapseMode: CollapseMode.parallax,
                        background: Container(
                          padding: EdgeInsets.only(top: minExtent),
                          child: Stack(
                            children: [
                              DotaItemMarketDetailSubview(item: widget.item),
                              // Gradient overlay that fades to black when collapsed
                              Positioned.fill(
                                child: Container(
                                  color: AppColors.black.withAlpha(
                                    (255 * 1.0 * (1 - t)).toInt(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Pinned Action Buttons and Tabs Section
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 74,
                  flexibleSpace: Container(
                    color: AppColors.black,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 0,
                    ),
                    child: Column(
                      children: [
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement post item functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Post this item',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // TODO(tenten): Implement place buy order functionality
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Place buy order',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tabs
                        BlocBuilder<OffersListCubit, OffersListState>(
                          bloc:
                              context
                                  .read<DotaItemDetailCubit>()
                                  .offersListCubit,
                          builder: (context, state) {
                            return TabBar(
                              controller: _tabController,
                              labelColor: Colors.white,
                              unselectedLabelColor: AppColors.grey,
                              indicatorColor: AppColors.primary,
                              tabs: [
                                Tab(
                                  text: I18n.of(context).dotaItemDetailOffers(
                                    state.totalOffersCount.toString(),
                                  ),
                                ),
                                // TODO(tenten): Add buy orders count
                                Tab(
                                  text: I18n.of(
                                    context,
                                  ).dotaItemDetailBuyOrders(0),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Dynamic Tab Content as Slivers
                if (_tabController.index == 0)
                  // Offers Tab Content
                  SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.75,
                      ),
                      child: const ColoredBox(
                        color: AppColors.black,
                        child: OffersListView(),
                      ),
                    ),
                  )
                else
                  // Buy Orders Tab Content
                  SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: Container(
                        color: AppColors.black,
                        padding: const EdgeInsets.all(64),
                        child: const Center(
                          child: Text(
                            'Buy orders will be shown here',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DotaItemDetailCubit>();
    cubit.setItemId(widget.item.id);

    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          // TODO(tenten): this is to refresh tab state, find a different way instead of empty set state
        });
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from the bottom
      if (_tabController.index == 0) {
        // Only load more offers if we're on the Offers tab
        final dotaItemDetailCubit = context.read<DotaItemDetailCubit>();
        final state = dotaItemDetailCubit.offersListCubit.state;
        if (state.totalOffersCount > state.offers.length &&
            !state.isLoadingMore) {
          unawaited(dotaItemDetailCubit.loadMoreOffers());
        }
      }
    }
  }
}
