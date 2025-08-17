import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/domain/usecases/cancel_reserve_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/deliver_my_listing_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_market_summary_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_listings_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyListingsCubit extends BaseCubit<MyListingsState>
    with CubitErrorMixin<MyListingsState> {
  static const int _pageLimit = 20;

  int _currentPage = 1;
  String _searchQuery = '';

  final Logger _logger;

  final DebouncerUtils _debouncerUtils;
  final GetMyListingsUsecase _getMyListingsUsecase;
  final GetMarketSummaryUsecase _getMarketSummaryUsecase;
  final CancelReserveMyListingUsecase _cancelReserveMyListingUsecase;
  final DeliverMyListingUsecase _deliverMyListingUsecase;

  MyListingsCubit(
    this._logger,
    this._getMyListingsUsecase,
    this._getMarketSummaryUsecase,
    this._debouncerUtils,
    this._cancelReserveMyListingUsecase,
    this._deliverMyListingUsecase,
  ) : super(const MyListingsState());

  @override
  Logger get logger => _logger;

  String get searchQuery => _searchQuery;

  void filterBy(int status) {
    if (state.status == status) {
      return;
    }

    emit(state.copyWith(status: status));
    unawaited(getMyListings());
  }

  Future<void> getMyListings() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    await cubitHandler(
      () => _getMyListingsUsecase.get(
        limit: _pageLimit,
        page: 1,
        status: state.status,
        searchQuery: _searchQuery,
      ),
      (response) async {
        final (listings, totalCount) = response;

        _currentPage = 1;

        emit(
          state.copyWith(listings: listings, totalListingsCount: totalCount),
        );
      },
    );

    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> init() async {
    _debouncerUtils.milliseconds = 500;
    unawaited(getMyListings());
    unawaited(_getMarketSummary());
  }

  Future<void> loadMoreListings() async {
    if (state.isLoadingMore) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.listings.length < state.totalListingsCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    await cubitHandler(
      () => _getMyListingsUsecase.get(
        limit: _pageLimit,
        page: nextPage,
        status: state.status,
        searchQuery: _searchQuery,
      ),
      (response) async {
        final (newListings, totalCount) = response;

        final combinedListings = [...state.listings, ...newListings];

        _currentPage = nextPage;

        emit(
          state.copyWith(
            listings: combinedListings,
            totalListingsCount: totalCount,
          ),
        );
      },
    );

    emit(state.copyWith(isLoadingMore: false));
  }

  Future<void> refreshListings() async {
    unawaited(getMyListings());
    unawaited(_getMarketSummary());
  }

  Future<void> searchListings(String query) async {
    // Reset pagination state for new searches
    if (query != _searchQuery) {
      _currentPage = 1;
    }

    _searchQuery = query;

    _debouncerUtils.run(() async {
      await getMyListings();
    });
  }

  Future<void> _getMarketSummary() async {
    await cubitHandler(
      _getMarketSummaryUsecase.get,
      (response) async => emit(state.copyWith(marketSummary: response)),
      onError: (e, st) async {
        emit(state.copyWith(marketSummary: null));
        _logger.log(LogLevel.error, 'Error getting market summary', e, st);
      },
    );
  }
}
