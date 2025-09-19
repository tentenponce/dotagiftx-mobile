import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/api/dotagiftx_unauth_api.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_dota_items_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PostItemCubit extends BaseCubit<PostItemState>
    with CubitErrorMixin<PostItemState> {
  final Logger _logger;
  final DotagiftxUnauthApi _dotagiftxUnauthApi;
  final GetDotaItemsUsecase _getDotaItemsUsecase;

  List<DotaItemModel> _items = [];
  double price = 0;
  int quantity = 0;

  PostItemCubit(
    this._logger,
    this._getDotaItemsUsecase,
    this._dotagiftxUnauthApi,
  ) : super(const PostItemState());

  @override
  Logger get logger => _logger;

  void clearSelectedItem() {
    emit(state.copyWith(selectedItem: null, items: _items));
  }

  void filterItems(String query) {
    emit(state.copyWith(selectedItem: null));
    if (query.isEmpty) {
      emit(state.copyWith(items: _items));
    } else {
      emit(
        state.copyWith(
          items:
              _items
                  .toList()
                  .where(
                    // hack to search by hero and name aligning with display in view
                    (item) => '${item.hero ?? ''} - ${item.name ?? ''}'
                        .toLowerCase()
                        .contains(query.toLowerCase()),
                  )
                  .toList(),
        ),
      );
    }
  }

  @override
  Future<void> init() async {
    unawaited(_getDotaItems());
  }

  void postItem() {
    if (state.selectedItem == null || price == 0 || quantity == 0) {
      return;
    }
  }

  void selectItem(DotaItemModel item) {
    emit(state.copyWith(selectedItem: item, items: _items));

    unawaited(
      cubitHandler(
        () => _dotagiftxUnauthApi.getCatalogBySlug(item.slug ?? ''),
        (item) async {
          emit(state.copyWith(selectedItem: item));
        },
      ),
    );
  }

  Future<void> _getDotaItems() async {
    emit(state.copyWith(isGetItemsLoading: true));
    await cubitHandler(_getDotaItemsUsecase.get, (items) async {
      _items = items.toList();
      emit(state.copyWith(items: _items));
    });
    emit(state.copyWith(isGetItemsLoading: false));
  }
}
