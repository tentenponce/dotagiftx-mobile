import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/dota_item_market_detail_subview.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/offers_list_view.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/dota_item_detail_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
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
            expandedHeight: 550,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final minExtent =
                    kToolbarHeight + MediaQuery.of(context).padding.top;
                const double maxExtent = 200;

                final t = ((constraints.maxHeight - minExtent) /
                        (maxExtent - minExtent))
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
                    child: DotaItemMarketDetailSubview(item: widget.item),
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
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                            // TODO: Implement place buy order functionality
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.primary,
                    tabs: const [Tab(text: 'Offers'), Tab(text: 'Buy Orders')],
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
                  minHeight: MediaQuery.of(context).size.height * 0.8,
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
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from the bottom
      if (_tabController.index == 0) {
        // Only load more offers if we're on the Offers tab
        final offersCubit = context.read<DotaItemDetailCubit>();
        final state = offersCubit.state;
        if (state.hasMoreData && !state.isLoadingMore) {
          offersCubit.loadMoreOffers();
        }
      }
    }
  }
}
