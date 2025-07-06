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

  String? itemId;
  int _currentPage = 1;

  DotaItemDetailCubit(this._logger, this._getOffersUsecase)
    : super(const DotaItemDetailState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {}

  Future<void> loadMoreOffers() async {
    if (state.isLoadingMore || itemId == null) {
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
      () => _getOffersUsecase.get(itemId: itemId!, page: nextPage),
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

  Future<void> loadOffers() async {
    if (state.isLoading || itemId == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    await cubitHandler(() => _getOffersUsecase.get(itemId: itemId!, page: 1), (
      response,
    ) async {
      final (offers, totalCount) = response;

      _currentPage = 1;
      emit(
        state.copyWith(
          offers: offers,
          totalOffersCount: totalCount,
          isLoading: false,
        ),
      );
    });

    emit(state.copyWith(isLoading: false));
  }

  Future<void> refresh() async {
    emit(const DotaItemDetailState());
    _currentPage = 1;
    await loadOffers();
  }
}
