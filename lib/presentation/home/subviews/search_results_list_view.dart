import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/trending_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class SearchResultsListView extends StatelessWidget {
  final List<DotaItemModel> searchResults;
  final Future<void> Function() onRefresh;

  const SearchResultsListView({
    required this.searchResults,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      // TODO: add pagination
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: searchResults.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader(
              I18n.of(context).homeSearchResults(searchResults.length),
            );
          }
          return TrendingItemCardView(item: searchResults[index - 1]);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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
}
