import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_my_listings_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/states/my_listings_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyListingsCubit extends BaseCubit<MyListingsState>
    with CubitErrorMixin<MyListingsState> {
  static const int _pageLimit = 20;
  final Logger _logger;

  int _currentPage = 1;

  final GetMyListingsUsecase _getMyListingsUsecase;

  MyListingsCubit(this._logger, this._getMyListingsUsecase)
    : super(const MyListingsState());

  @override
  Logger get logger => _logger;

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
    await getMyListings();
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
    await getMyListings();
  }
}
