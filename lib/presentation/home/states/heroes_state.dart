import 'package:dotagiftx_mobile/domain/models/hero_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'heroes_state.freezed.dart';

@freezed
abstract class HeroesState with _$HeroesState {
  const factory HeroesState({
    @Default(false) bool loadingHeroes,
    @Default([]) List<HeroModel> heroes,
  }) = _HeroesState;
}
