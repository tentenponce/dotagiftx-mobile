import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotagiftxImageCubit extends BaseCubit<String> with CubitErrorMixin {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  DotagiftxImageCubit(this._logger, this._dotagiftxRemoteConfig)
    : super(RemoteConfigConstants.defaultDotagiftxImageBaseUrl);

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    await cubitHandler<String>(
      _dotagiftxRemoteConfig.getDotagiftxImageBaseUrl,
      (dotagiftxImageBaseUrl) async {
        emit(
          !StringUtils.isNullOrEmpty(dotagiftxImageBaseUrl)
              ? dotagiftxImageBaseUrl
              : RemoteConfigConstants.defaultDotagiftxImageBaseUrl,
        );
      },
      onError:
          (error) async =>
              emit(RemoteConfigConstants.defaultDotagiftxImageBaseUrl),
    );
  }
}
