import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_item_offers_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/states/dota_item_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotaItemDetailCubit extends BaseCubit<DotaItemDetailState>
    with CubitErrorMixin<DotaItemDetailState> {
  final Logger _logger;
  final GetDotaItemOffersUsecase _getOffersUsecase;

  int _currentPage = 1;
  String? _itemId;

  DotaItemDetailCubit(this._logger, this._getOffersUsecase)
    : super(const DotaItemDetailState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {}

  Future<void> loadMoreOffers() async {
    if (state.isLoadingMore) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.offers.length < state.totalOffersCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    await cubitHandler(
      () => _getOffersUsecase.get(itemId: _itemId!, page: nextPage),
      (response) async {
        final (newOffers, totalCount) = response;

        final combinedOffers = [...state.offers, ...newOffers];

        _currentPage = nextPage;
        emit(
          state.copyWith(
            offers: combinedOffers,
            totalOffersCount: totalCount,
            isLoadingMore: false,
          ),
        );
      },
    );

    emit(state.copyWith(isLoadingMore: false));
  }

  void onSwipeToRefresh() {
    unawaited(_getNewOffers());
  }

  // String? itemId;

  void setItemId(String? value) {
    _itemId = value;
    unawaited(_getNewOffers());
  }

  Future<void> _getNewOffers() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    await cubitHandler(() => _getOffersUsecase.get(itemId: _itemId!, page: 1), (
      response,
    ) async {
      final (offers, totalCount) = response;

      _currentPage = 1;
      emit(state.copyWith(offers: offers, totalOffersCount: totalCount));
    });

    emit(state.copyWith(isLoading: false));
  }
}
