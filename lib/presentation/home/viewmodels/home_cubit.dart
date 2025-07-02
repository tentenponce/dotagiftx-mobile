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
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> with CubitErrorMixin<HomeState> {
  final Logger _logger;
  final GetTrendingUsecase _getTrendingUsecase;
  final GetNewBuyOrdersUsecase _getNewBuyOrdersUsecase;
  final GetNewSellListingsUsecase _getNewSellListingsUsecase;
  final SearchCatalogUsecase _searchCatalogUsecase;
  final DebouncerUtils _debouncerUtils;

  HomeCubit(
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

  Future<void> searchCatalog({required String query, int page = 1}) async {
    if (query.isEmpty) {
      _debouncerUtils.cancel();
      emit(state.copyWith(searchResults: []));
      return;
    }

    // TODO: add shimmering effect
    _debouncerUtils.run(() async {
      await cubitHandler(
        () => _searchCatalogUsecase.search(query: query, page: page),
        (response) async => emit(state.copyWith(searchResults: response)),
      );
    });
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
