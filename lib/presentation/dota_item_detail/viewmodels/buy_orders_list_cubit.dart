import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BuyOrdersListCubit extends BaseCubit<BuyOrdersListState>
    with CubitErrorMixin<BuyOrdersListState> {
  final Logger _logger;
  final GetDotaItemOrdersUsecase _getOrdersUsecase;

  int _currentPage = 1;
  String _itemId = '';

  BuyOrdersListCubit(this._logger, this._getOrdersUsecase)
    : super(const BuyOrdersListState()) {
    _logger.logFor(this);
  }

  @override
  Logger get logger => _logger;

  Future<void> getNewBuyOrders() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    await cubitHandler(
      () => _getOrdersUsecase.get(itemId: _itemId, page: 1, sort: state.sort),
      (response) async {
        final (buyOrders, totalCount) = response;

        _currentPage = 1;
        emit(
          state.copyWith(buyOrders: buyOrders, totalBuyOrdersCount: totalCount),
        );
      },
    );

    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> init() async {}

  Future<void> loadMoreBuyOrders() async {
    if (state.isLoadingMore) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.buyOrders.length < state.totalBuyOrdersCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    await cubitHandler(
      () => _getOrdersUsecase.get(
        itemId: _itemId,
        page: nextPage,
        sort: state.sort,
      ),
      (response) async {
        final (newBuyOrders, totalCount) = response;

        final updatedBuyOrders = [...state.buyOrders, ...newBuyOrders];

        _currentPage = nextPage;
        emit(
          state.copyWith(
            buyOrders: updatedBuyOrders,
            totalBuyOrdersCount: totalCount,
          ),
        );
      },
    );

    emit(state.copyWith(isLoadingMore: false));
  }

  void setItemId(String itemId) {
    _itemId = itemId;
    unawaited(getNewBuyOrders());
  }

  void sortBy(String sort) {
    if (state.sort == sort) {
      return;
    }

    emit(state.copyWith(sort: sort));
    unawaited(getNewBuyOrders());
  }
}
