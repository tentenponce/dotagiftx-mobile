import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treasures_state.freezed.dart';

@freezed
abstract class TreasuresState with _$TreasuresState {
  const factory TreasuresState({
    @Default(false) bool loadingTreasures,
    @Default([]) List<TreasureModel> treasures,
  }) = _TreasuresState;
}
