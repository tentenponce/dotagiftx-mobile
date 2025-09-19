import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_item_state.freezed.dart';

@freezed
abstract class PostItemState with _$PostItemState {
  const factory PostItemState({
    @Default(false) bool isPostItemLoading,
    @Default(false) bool isGetItemsLoading,
    @Default([]) List<DotaItemModel> items,
    @Default(null) DotaItemModel? selectedItem,
  }) = _PostItemState;
}
