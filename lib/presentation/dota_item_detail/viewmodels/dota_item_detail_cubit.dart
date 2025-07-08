import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/dota_item_detail_state.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/buy_orders_list_cubit.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotaItemDetailCubit extends BaseCubit<DotaItemDetailState>
    with CubitErrorMixin<DotaItemDetailState> {
  final OffersListCubit offersListCubit;
  final BuyOrdersListCubit buyOrdersListCubit;

  final Logger _logger;

  String? _itemId;

  DotaItemDetailCubit(
    this.offersListCubit,
    this.buyOrdersListCubit,
    this._logger,
  ) : super(const DotaItemDetailState()) {
    _logger.logFor(this);
  }

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {}

  void onSwipeToRefresh() {
    if (StringUtils.isNullOrEmpty(_itemId)) {
      _logger.log(
        LogLevel.error,
        'onSwipeToRefresh > Item ID is null or empty',
      );
      return;
    }

    unawaited(offersListCubit.getNewOffers());
    unawaited(buyOrdersListCubit.getNewBuyOrders());
  }

  void onTabChanged(MarketTab tab) {
    emit(state.copyWith(tab: tab));
  }

  void setItemId(String? value) {
    _itemId = value;

    if (StringUtils.isNullOrEmpty(_itemId)) {
      _logger.log(LogLevel.error, 'setItemId > Item ID is null or empty');
      return;
    }

    offersListCubit.setItemId(_itemId!);
    buyOrdersListCubit.setItemId(_itemId!);
  }
}
