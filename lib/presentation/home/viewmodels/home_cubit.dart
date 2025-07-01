import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_buy_orders_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_new_sell_listings_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_trending_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> with CubitErrorMixin<HomeState> {
  final Logger _logger;
  final GetTrendingUsecase _getTrendingUsecase;
  final GetNewBuyOrdersUsecase _getNewBuyOrdersUsecase;
  final GetNewSellListingsUsecase _getNewSellListingsUsecase;

  HomeCubit(
    this._logger,
    this._getTrendingUsecase,
    this._getNewBuyOrdersUsecase,
    this._getNewSellListingsUsecase,
  ) : super(const HomeState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    unawaited(_getTrendingItems());
    unawaited(_getNewBuyOrders());
    unawaited(_getNewSellListings());
  }

  Future<void> _getNewBuyOrders() async {
    await cubitHandler(
      _getNewBuyOrdersUsecase.get,
      (response) async => emit(state.copyWith(newBuyOrderItems: response)),
    );
  }

  Future<void> _getNewSellListings() async {
    await cubitHandler(
      _getNewSellListingsUsecase.get,
      (response) async => emit(state.copyWith(newSellListingItems: response)),
    );
  }

  Future<void> _getTrendingItems() async {
    await cubitHandler(
      _getTrendingUsecase.get,
      (response) async => emit(state.copyWith(trendingItems: response)),
    );
  }
}
