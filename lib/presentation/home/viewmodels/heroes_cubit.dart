import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/hero_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/heroes_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HeroesCubit extends BaseCubit<HeroesState>
    with CubitErrorMixin<HeroesState> {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  String searchQuery = '';
  List<HeroModel> _heroes = [];

  HeroesCubit(this._logger, this._dotagiftxRemoteConfig)
    : super(const HeroesState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    unawaited(_fetchHeroes());
  }

  void onSwipeToRefresh() {
    unawaited(_fetchHeroes());
  }

  void searchHero(String searchQuery) {
    this.searchQuery = searchQuery;

    _emitFilteredHeroes();
  }

  void _emitFilteredHeroes() {
    final filteredHeroes =
        !StringUtils.isNullOrEmpty(searchQuery)
            ? _heroes.where(
              (hero) =>
                  hero.name?.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ??
                  false,
            )
            : _heroes;

    emit(state.copyWith(heroes: filteredHeroes.toList()));
  }

  Future<void> _fetchHeroes() async {
    emit(state.copyWith(loadingHeroes: true));

    await cubitHandler(_dotagiftxRemoteConfig.getHeroes, (heroes) async {
      _heroes = heroes.toList();
      _emitFilteredHeroes();
    });

    emit(state.copyWith(loadingHeroes: false));
  }
}
