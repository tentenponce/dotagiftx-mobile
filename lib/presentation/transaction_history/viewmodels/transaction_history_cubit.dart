import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_all_my_listings_history_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_completed_orders_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_delivered_listings_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_to_receive_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/transaction_history/states/transaction_history_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransactionHistoryCubit extends BaseCubit<TransactionHistoryState>
    with CubitErrorMixin<TransactionHistoryState> {
  static const int _pageLimit = 20;

  int _currentPage = 1;
  String _searchQuery = '';

  final Logger _logger;

  final DebouncerUtils _debouncerUtils;
  final GetAllMyListingsHistoryUsecase _getAllMyListingsHistoryUsecase;
  final GetToReceiveOrdersUsecase _getToReceiveOrdersUsecase;
  final GetMyDeliveredListingsUsecase _getMyDeliveredListingsUsecase;
  final GetMyCompletedOrdersUsecase _getMyCompletedOrdersUsecase;

  TransactionHistoryCubit(
    this._logger,
    this._getAllMyListingsHistoryUsecase,
    this._getToReceiveOrdersUsecase,
    this._getMyDeliveredListingsUsecase,
    this._getMyCompletedOrdersUsecase,
    this._debouncerUtils,
  ) : super(const TransactionHistoryState());

  @override
  Logger get logger => _logger;

  String get searchQuery => _searchQuery;

  void filterBy(TransactionHistoryFilter filter) {
    if (state.filter == filter) {
      return;
    }

    emit(state.copyWith(filter: filter));
    unawaited(getTransactions());
  }

  Future<void> getTransactions() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    await cubitHandler(() => _getUsecaseByFilter(page: 1), (response) async {
      final (transactions, totalCount) = response;

      _currentPage = 1;

      emit(
        state.copyWith(
          transactions: transactions,
          totalTransactionsCount: totalCount,
        ),
      );
    });

    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> init() async {
    _debouncerUtils.milliseconds = 500;
    unawaited(getTransactions());
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoadingMore) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.transactions.length < state.totalTransactionsCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    await cubitHandler(() => _getUsecaseByFilter(page: nextPage), (
      response,
    ) async {
      final (newTransactions, totalCount) = response;

      final combinedTransactions = [...state.transactions, ...newTransactions];

      _currentPage = nextPage;

      emit(
        state.copyWith(
          transactions: combinedTransactions,
          totalTransactionsCount: totalCount,
        ),
      );
    });

    emit(state.copyWith(isLoadingMore: false));
  }

  Future<void> refreshTransactions() async {
    await getTransactions();
  }

  Future<void> searchTransactions(String query) async {
    // Reset pagination state for new searches
    if (query != _searchQuery) {
      _currentPage = 1;
    }

    _searchQuery = query;

    _debouncerUtils.run(() async {
      await getTransactions();
    });
  }

  Future<(List<MarketListingModel>, int)> _getUsecaseByFilter({
    required int page,
  }) async {
    switch (state.filter) {
      case TransactionHistoryFilter.all:
        return _getAllMyListingsHistoryUsecase.get(
          limit: _pageLimit,
          page: page,
          searchQuery: _searchQuery,
        );
      case TransactionHistoryFilter.delivered:
        return _getMyDeliveredListingsUsecase.get(
          limit: _pageLimit,
          page: page,
          searchQuery: _searchQuery,
        );
      case TransactionHistoryFilter.toReceive:
        return _getToReceiveOrdersUsecase.get(limit: _pageLimit, page: page);
      case TransactionHistoryFilter.completed:
        return _getMyCompletedOrdersUsecase.get(
          limit: _pageLimit,
          page: page,
          searchQuery: _searchQuery,
        );
    }
  }
}
