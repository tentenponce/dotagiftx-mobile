import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_orders_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/buy_orders_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BuyOrdersListCubit extends BaseCubit<BuyOrdersListState>
    with CubitErrorMixin<BuyOrdersListState> {
  final Logger _logger;
  final GetDotaItemOrdersUsecase _getDotaItemOrdersUsecase;

  String? _itemId;

  BuyOrdersListCubit(this._logger, this._getDotaItemOrdersUsecase)
    : super(const BuyOrdersListState()) {
    _logger.logFor(this);
  }

  @override
  Logger get logger => _logger;

  Future<void> getNewBuyOrders() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true, currentPage: 1));

    await cubitHandler(
      () => _getDotaItemOrdersUsecase.get(
        itemId: _itemId!,
        page: 1,
        sort: state.sort,
      ),
      (response) async {
        final (buyOrders, totalCount) = response;
        emit(
          state.copyWith(
            buyOrders: buyOrders,
            totalBuyOrdersCount: totalCount,
            currentPage: 1,
            isLoading: false,
          ),
        );
      },
    );

    emit(state.copyWith(isLoading: false));
  }

  @override
  Future<void> init() async {}

  Future<void> loadMoreBuyOrders() async {
    if (state.isLoadingMore ||
        state.buyOrders.length >= state.totalBuyOrdersCount) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    await cubitHandler(
      () => _getDotaItemOrdersUsecase.get(
        itemId: _itemId!,
        page: nextPage,
        sort: state.sort,
      ),
      (response) async {
        final (newBuyOrders, totalCount) = response;
        final updatedBuyOrders = [...state.buyOrders, ...newBuyOrders];
        emit(
          state.copyWith(
            buyOrders: updatedBuyOrders,
            totalBuyOrdersCount: totalCount,
            currentPage: nextPage,
            isLoadingMore: false,
          ),
        );
      },
    );

    emit(state.copyWith(isLoadingMore: false));
  }

  void setItemId(String itemId) {
    if (StringUtils.isNullOrEmpty(itemId)) {
      logger.log(LogLevel.error, 'setItemId > Item ID is null or empty');
      return;
    }

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
