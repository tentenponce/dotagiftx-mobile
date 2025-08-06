import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotagiftxImageCubit extends BaseCubit<String> with CubitErrorMixin {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;
  final EnvironmentVariables _environmentVariables;

  DotagiftxImageCubit(
    this._logger,
    this._dotagiftxRemoteConfig,
    this._environmentVariables,
  ) : super(RemoteConfigConstants.defaultDotagiftxImageEndpoint);

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
              : '${_environmentVariables.baseUrl}${RemoteConfigConstants.defaultDotagiftxImageEndpoint}',
        );
      },
      onError:
          (error) async => emit(
            '${_environmentVariables.baseUrl}${RemoteConfigConstants.defaultDotagiftxImageEndpoint}',
          ),
    );
  }
}
