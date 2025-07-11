import 'dart:convert';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_remote_config/app_remote_config.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/hero_model.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract interface class DotagiftxRemoteConfig {
  Future<String> getDotagiftxImageBaseUrl();

  Future<Iterable<HeroModel>> getHeroes();

  Future<Iterable<RoadmapModel>> getRoadmap();

  Future<Iterable<TreasureModel>> getTreasures();
}

@LazySingleton(as: DotagiftxRemoteConfig)
class DotagiftxRemoteConfigImpl implements DotagiftxRemoteConfig {
  final Logger _logger;
  final AppRemoteConfig _appRemoteConfig;

  DotagiftxRemoteConfigImpl(this._logger, this._appRemoteConfig);

  @override
  Future<String> getDotagiftxImageBaseUrl() async {
    final dotagiftxImageBaseUrl = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyDotagiftxImageBaseUrl,
    );

    return dotagiftxImageBaseUrl ??
        RemoteConfigConstants.defaultDotagiftxImageBaseUrl;
  }

  @override
  Future<Iterable<HeroModel>> getHeroes() async {
    // TODO(dev): get from remote config
    final heroesString = await rootBundle.loadString(Assets.json.heroes);
    final heroesJson = jsonDecode(heroesString) as List<dynamic>;
    return heroesJson.map((e) => HeroModel.fromJson(e as Map<String, dynamic>));
  }

  @override
  Future<Iterable<RoadmapModel>> getRoadmap() async {
    final roadmapString = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyRoadmap,
    );

    if (!StringUtils.isNullOrEmpty(roadmapString)) {
      try {
        final roadmapJson = jsonDecode(roadmapString!) as List<dynamic>;
        return roadmapJson
            .map((e) => e as Map<String, dynamic>)
            .map(RoadmapModel.fromJson);
      } catch (e) {
        _logger.log(
          LogLevel.error,
          'Error parsing roadmap from remote config',
          e,
        );
        return RemoteConfigConstants.defaultRoadmap;
      }
    }

    return RemoteConfigConstants.defaultRoadmap;
  }

  @override
  Future<Iterable<TreasureModel>> getTreasures() async {
    final treasuresString = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyTreasures,
    );

    if (!StringUtils.isNullOrEmpty(treasuresString)) {
      try {
        final treasuresJson = jsonDecode(treasuresString!) as List<dynamic>;
        return treasuresJson
            .map((e) => e as Map<String, dynamic>)
            .map(TreasureModel.fromJson);
      } catch (e) {
        _logger.log(
          LogLevel.error,
          'Error parsing treasures from remote config',
          e,
        );
        return RemoteConfigConstants.defaultTreasures;
      }
    }

    return RemoteConfigConstants.defaultTreasures;
  }
}
