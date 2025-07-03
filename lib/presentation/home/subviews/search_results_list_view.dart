import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/shimmer_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/trending_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class SearchResultsListView extends StatelessWidget {
  final List<DotaItemModel> searchResults;
  final Future<void> Function() onRefresh;
  final bool isLoading;

  const SearchResultsListView({
    required this.searchResults,
    required this.onRefresh,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      // TODO(tenten): add pagination
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _getItemCount(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader(context);
          }

          if (isLoading) {
            return const ShimmerItemCardView();
          }

          return TrendingItemCardView(item: searchResults[index - 1]);
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }
    return _buildStaticSectionHeader(
      I18n.of(context).homeSearchResults(searchResults.length),
    );
  }

  Widget _buildStaticSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  int _getItemCount() {
    if (isLoading) {
      return 6; // 1 header + 5 shimmer items
    }
    return searchResults.length + 1; // 1 header + actual results
  }
}
