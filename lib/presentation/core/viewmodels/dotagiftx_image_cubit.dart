import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/config/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotagiftxImageCubit extends BaseCubit<String> {
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;

  DotagiftxImageCubit(this._dotagiftxRemoteConfig)
    : super(RemoteConfigConstants.defaultDotagiftxImageBaseUrl);

  @override
  Future<void> init() async {
    final dotagiftxImageBaseUrl =
        await _dotagiftxRemoteConfig.getDotagiftxImageBaseUrl();
    emit(
      !StringUtils.isNullOrEmpty(dotagiftxImageBaseUrl)
          ? dotagiftxImageBaseUrl
          : RemoteConfigConstants.defaultDotagiftxImageBaseUrl,
    );
  }
}
