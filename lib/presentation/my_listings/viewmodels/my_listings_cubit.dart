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

  final GetMyListingsUsecase _getMyListingsUsecase;

  MyListingsCubit(this._logger, this._getMyListingsUsecase)
    : super(const MyListingsState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    await loadListings();
  }

  Future<void> loadListings({int? status}) async {
    emit(
      state.copyWith(
        currentPage: 1,
        listings: [],
        loadingListings: true,
        status: status ?? state.status,
      ),
    );

    await cubitHandler(
      () => _getMyListingsUsecase.get(
        limit: _pageLimit,
        page: 1,
        status: state.status,
      ),
      (response) async {
        final (listings, totalCount) = response;

        emit(
          state.copyWith(
            listings: listings,
            totalListingsCount: totalCount,
            currentPage: 1,
          ),
        );
      },
    );

    emit(state.copyWith(loadingListings: false));
  }

  Future<void> loadMoreListings() async {
    if (state.loadingMoreListings || state.loadingListings) {
      return;
    }

    // Check if there are more results based on total count
    final hasMore = state.listings.length < state.totalListingsCount;
    if (!hasMore) {
      return;
    }

    emit(state.copyWith(loadingMoreListings: true));

    final nextPage = state.currentPage + 1;

    await cubitHandler(
      () => _getMyListingsUsecase.get(limit: _pageLimit, page: nextPage),
      (response) async {
        final (newListings, totalCount) = response;

        final combinedListings = [...state.listings, ...newListings];

        emit(
          state.copyWith(
            listings: combinedListings,
            totalListingsCount: totalCount,
            currentPage: nextPage,
          ),
        );
      },
    );

    emit(state.copyWith(loadingMoreListings: false));
  }

  Future<void> refreshListings() async {
    await loadListings();
  }
}
