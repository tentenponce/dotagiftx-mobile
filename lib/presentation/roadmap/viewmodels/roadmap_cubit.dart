import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoadmapCubit extends BaseCubit<List<RoadmapModel>>
    with CubitErrorMixin<List<RoadmapModel>> {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  RoadmapCubit(this._logger, this._dotagiftxRemoteConfig)
    : super(RemoteConfigConstants.defaultRoadmap.toList());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    await cubitHandler<Iterable<RoadmapModel>>(
      _dotagiftxRemoteConfig.getRoadmap,
      (roadmap) async {
        emit(roadmap.toList());
      },
    );
  }
}
