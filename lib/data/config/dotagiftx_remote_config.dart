import 'dart:convert';

import 'package:dotagiftx_mobile/core/platform/app_remote_config/app_remote_config.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class DotagiftxRemoteConfig {
  Future<String> getDotagiftxImageBaseUrl();

  Future<Iterable<TreasureModel>> getTreasures();
}

@LazySingleton(as: DotagiftxRemoteConfig)
class DotagiftxRemoteConfigImpl implements DotagiftxRemoteConfig {
  final AppRemoteConfig _appRemoteConfig;

  DotagiftxRemoteConfigImpl(this._appRemoteConfig);

  @override
  Future<String> getDotagiftxImageBaseUrl() async {
    final dotagiftxImageBaseUrl = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyDotagiftxImageBaseUrl,
    );

    return dotagiftxImageBaseUrl ??
        RemoteConfigConstants.defaultDotagiftxImageBaseUrl;
  }

  @override
  Future<Iterable<TreasureModel>> getTreasures() async {
    final treasuresString = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyTreasures,
    );

    if (!StringUtils.isNullOrEmpty(treasuresString)) {
      final treasuresJson = jsonDecode(treasuresString!) as List<dynamic>;
      return treasuresJson
          .map((e) => e as Map<String, dynamic>)
          .map(TreasureModel.fromJson);
    }

    return RemoteConfigConstants.defaultTreasures;
  }
}
