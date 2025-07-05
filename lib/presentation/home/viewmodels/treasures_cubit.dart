import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/home/states/treasures_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TreasuresCubit extends BaseCubit<TreasuresState>
    with CubitErrorMixin<TreasuresState> {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  TreasuresCubit(this._logger, this._dotagiftxRemoteConfig)
    : super(const TreasuresState());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    unawaited(_getTreasures());
  }

  void onSwipeToRefresh() {
    unawaited(_getTreasures());
  }

  Future<void> _getTreasures() async {
    emit(state.copyWith(loadingTreasures: true));

    await cubitHandler<Iterable<TreasureModel>>(
      _dotagiftxRemoteConfig.getTreasures,
      (treasures) async => emit(state.copyWith(treasures: treasures)),
    );

    emit(state.copyWith(loadingTreasures: false));
  }
}
