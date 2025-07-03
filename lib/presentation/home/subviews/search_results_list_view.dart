import 'dart:async';
import 'dart:math';

import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/shimmer_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/trending_item_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsListView extends StatefulWidget {
  final List<DotaItemModel> searchResults;
  final Future<void> Function() onRefresh;
  final bool isLoading;
  final int totalSearchResultsCount;
  final bool loadingMoreResults;

  const SearchResultsListView({
    required this.searchResults,
    required this.onRefresh,
    this.isLoading = false,
    this.totalSearchResultsCount = 0,
    this.loadingMoreResults = false,
    super.key,
  });

  @override
  State<SearchResultsListView> createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _getItemCount(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader(context);
          }

          // Show shimmer items when initially loading
          if (widget.isLoading) {
            return const ShimmerItemCardView();
          }

          // Check if this is a loading more shimmer item
          if (widget.loadingMoreResults &&
              index > widget.searchResults.length) {
            final remainingResults =
                widget.totalSearchResultsCount - widget.searchResults.length;
            final maxShimmerItems = min(remainingResults, 10);
            final shimmerIndex = index - widget.searchResults.length;
            if (shimmerIndex <= maxShimmerItems) {
              return const ShimmerItemCardView();
            }
          }

          // Regular search result items
          if (index <= widget.searchResults.length) {
            return TrendingItemCardView(item: widget.searchResults[index - 1]);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  Widget _buildSectionHeader(BuildContext context) {
    if (widget.isLoading) {
      return const SizedBox.shrink();
    }
    return _buildStaticSectionHeader(
      I18n.of(context).homeSearchResults(widget.totalSearchResultsCount),
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
    if (widget.isLoading) {
      return 6; // 1 header + 5 shimmer items
    }

    var count = widget.searchResults.length + 1; // 1 header + actual results

    // Add shimmer items based on remaining results when loading more (max 10)
    if (widget.loadingMoreResults) {
      final remainingResults =
          widget.totalSearchResultsCount - widget.searchResults.length;
      count += min(remainingResults, 10);
    }

    return count;
  }

  void _onScroll() {
    FocusScope.of(context).unfocus();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User is near the bottom, load more results
      if (widget.totalSearchResultsCount > widget.searchResults.length &&
          !widget.loadingMoreResults &&
          !widget.isLoading) {
        unawaited(context.read<HomeCubit>().loadMoreSearchResults());
      }
    }
  }
}
