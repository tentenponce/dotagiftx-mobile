import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/heroes_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HeroesCubit extends BaseCubit<HeroesState>
    with CubitErrorMixin<HeroesState> {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

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

  Future<void> _fetchHeroes() async {
    emit(state.copyWith(loadingHeroes: true));

    await cubitHandler(_dotagiftxRemoteConfig.getHeroes, (heroes) async {
      emit(state.copyWith(heroes: heroes.toList()));
    });

    emit(state.copyWith(loadingHeroes: false));
  }
}
