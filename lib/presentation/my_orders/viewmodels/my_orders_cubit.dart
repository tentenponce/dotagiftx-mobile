import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/debouncer_utils.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_market_summary_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/states/my_orders_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyOrdersCubit extends BaseCubit<MyOrdersState>
    with CubitErrorMixin<MyOrdersState> {
  static const int _pageLimit = 20;

  int _currentPage = 1;
  String _searchQuery = '';

  final Logger _logger;
  final GetMyOrdersUsecase _getMyOrdersUsecase;
  final GetMarketSummaryUsecase _getMarketSummaryUsecase;
  final DebouncerUtils _debouncerUtils;

  MyOrdersCubit(
    this._logger,
    this._getMyOrdersUsecase,
    this._getMarketSummaryUsecase,
    this._debouncerUtils,
  ) : super(const MyOrdersState());

  @override
  Logger get logger => _logger;

  String get searchQuery => _searchQuery;

  void filterBy(int status) {
    if (state.status == status) {
      return;
    }

    emit(state.copyWith(status: status));
    unawaited(getMyOrders());
  }

  Future<void> getMyOrders() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    await cubitHandler(
      () => _getMyOrdersUsecase.get(
        limit: _pageLimit,
        page: 1,
        status: state.status,
        searchQuery: _searchQuery,
      ),
      (response) async {
        final (orders, totalCount) = response;

        _currentPage = 1;

        emit(state.copyWith(orders: orders, totalOrdersCount: totalCount));
      },
    );

    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> init() async {
    _debouncerUtils.milliseconds = 500;
    unawaited(getMyOrders());
    unawaited(_getMarketSummary());
  }

  Future<void> loadMoreOrders() async {
    if (state.isLoadingMore) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.orders.length < state.totalOrdersCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    await cubitHandler(
      () => _getMyOrdersUsecase.get(
        limit: _pageLimit,
        page: nextPage,
        status: state.status,
        searchQuery: _searchQuery,
      ),
      (response) async {
        final (newOrders, totalCount) = response;

        final combinedOrders = [...state.orders, ...newOrders];

        _currentPage = nextPage;

        emit(
          state.copyWith(orders: combinedOrders, totalOrdersCount: totalCount),
        );
      },
    );

    emit(state.copyWith(isLoadingMore: false));
  }

  Future<void> refreshOrders() async {
    unawaited(getMyOrders());
    unawaited(_getMarketSummary());
  }

  Future<void> searchOrders(String query) async {
    // Reset pagination state for new searches
    if (query != _searchQuery) {
      _currentPage = 1;
    }

    _searchQuery = query;

    _debouncerUtils.run(() async {
      await getMyOrders();
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
