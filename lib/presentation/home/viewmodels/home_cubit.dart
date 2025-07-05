import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_buy_orders_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_sell_listings_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_trending_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/search_catalog_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/treasures_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> with CubitErrorMixin<HomeState> {
  final TreasuresCubit treasuresCubit;

  final Logger _logger;
  final GetTrendingUsecase _getTrendingUsecase;
  final GetNewBuyOrdersUsecase _getNewBuyOrdersUsecase;
  final GetNewSellListingsUsecase _getNewSellListingsUsecase;
  final SearchCatalogUsecase _searchCatalogUsecase;
  final DebouncerUtils _debouncerUtils;

  String _currentSearchQuery = '';
  int _currentSearchPage = 1;

  HomeCubit(
    this.treasuresCubit,
    this._logger,
    this._getTrendingUsecase,
    this._getNewBuyOrdersUsecase,
    this._getNewSellListingsUsecase,
    this._searchCatalogUsecase,
    this._debouncerUtils,
  ) : super(const HomeState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    _debouncerUtils.milliseconds = 500;
    unawaited(_getTrendingItems());
    unawaited(_getNewBuyOrders());
    unawaited(_getNewSellListings());
  }

  Future<void> loadMoreSearchResults() async {
    if (state.loadingMoreSearchResults || _currentSearchQuery.isEmpty) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.searchResults.length < state.totalSearchResultsCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(loadingMoreSearchResults: true));

    final nextPage = _currentSearchPage + 1;

    await cubitHandler(
      () => _searchCatalogUsecase.search(
        query: _currentSearchQuery,
        page: nextPage,
      ),
      (response) async {
        final (newResults, totalCount) = response;

        final combinedResults = [...state.searchResults, ...newResults];

        _currentSearchPage = nextPage;
        emit(
          state.copyWith(
            searchResults: combinedResults,
            totalSearchResultsCount: totalCount,
            loadingMoreSearchResults: false,
          ),
        );
      },
    );

    emit(state.copyWith(loadingMoreSearchResults: false));
  }

  Future<void> searchCatalog({required String query}) async {
    if (query.isEmpty) {
      _currentSearchQuery = query;
      _debouncerUtils.cancel();
      _currentSearchPage = 1;
      emit(
        state.copyWith(
          searchResults: [],
          loadingSearchResults: false,
          totalSearchResultsCount: 0,
        ),
      );
      return;
    }

    // Reset pagination state for new searches
    if (query != _currentSearchQuery) {
      _currentSearchPage = 1;
      emit(state.copyWith(searchResults: [], totalSearchResultsCount: 0));
    }

    _currentSearchQuery = query;
    emit(state.copyWith(loadingSearchResults: true));
    _debouncerUtils.run(() async {
      await cubitHandler(
        () => _searchCatalogUsecase.search(query: query, page: 1),
        (response) async {
          final (results, totalCount) = response;

          _currentSearchPage = 1;
          emit(
            state.copyWith(
              searchResults: results.toList(),
              totalSearchResultsCount: totalCount,
            ),
          );
        },
      );
      emit(state.copyWith(loadingSearchResults: false));
    });
  }

  Future<void> _getNewBuyOrders() async {
    emit(state.copyWith(loadingNewBuyOrderItems: true));
    await cubitHandler(
      _getNewBuyOrdersUsecase.get,
      (response) async => emit(
        state.copyWith(
          newBuyOrderItems: response.toList(),
          loadingNewBuyOrderItems: false,
        ),
      ),
    );
    emit(state.copyWith(loadingNewBuyOrderItems: false));
  }

  Future<void> _getNewSellListings() async {
    emit(state.copyWith(loadingNewSellListingItems: true));
    await cubitHandler(
      _getNewSellListingsUsecase.get,
      (response) async =>
          emit(state.copyWith(newSellListingItems: response.toList())),
    );
    emit(state.copyWith(loadingNewSellListingItems: false));
  }

  Future<void> _getTrendingItems() async {
    emit(state.copyWith(loadingTrendingItems: true));
    await cubitHandler(
      _getTrendingUsecase.get,
      (response) async =>
          emit(state.copyWith(trendingItems: response.toList())),
    );
    emit(state.copyWith(loadingTrendingItems: false));
  }
}
