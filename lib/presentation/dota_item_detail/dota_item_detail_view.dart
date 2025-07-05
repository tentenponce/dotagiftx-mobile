import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/subviews/dota_item_market_detail_subview.dart';
import 'package:flutter/material.dart';

class DotaItemDetailView extends StatefulWidget {
  final DotaItemModel item;

  const DotaItemDetailView({required this.item, super.key});

  @override
  State<DotaItemDetailView> createState() => _DotaItemDetailViewState();
}

class _DotaItemDetailViewState extends State<DotaItemDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Item Details Subview
          DotaItemMarketDetailSubview(item: widget.item),

          // Action Buttons and Tabs Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 24),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.grey,
                    indicatorColor: AppColors.primary,
                    tabs: const [Tab(text: 'Offers'), Tab(text: 'Buy Orders')],
                  ),
                  const SizedBox(height: 16),

                  // Tab Content (placeholder for now)
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        // Offers Tab
                        Center(
                          child: Text(
                            'Offers will be shown here',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ),
                        // Buy Orders Tab
                        Center(
                          child: Text(
                            'Buy orders will be shown here',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
}
