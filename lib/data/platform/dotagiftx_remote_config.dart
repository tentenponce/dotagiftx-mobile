import 'dart:convert';

import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_remote_config/app_remote_config.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/domain/models/hero_model.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/domain/models/theme_model.dart';
import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/shared/assets/assets.gen.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract interface class DotagiftxRemoteConfig {
  Future<String> getDotagiftxImageBaseUrl();

  Future<Iterable<HeroModel>> getHeroes();

  Future<Iterable<RoadmapModel>> getRoadmap();

  Future<ThemeModel> getTheme();

  Future<int> getTokenRotationSeconds();

  Future<Iterable<TreasureModel>> getTreasures();
}

@LazySingleton(as: DotagiftxRemoteConfig)
class DotagiftxRemoteConfigImpl implements DotagiftxRemoteConfig {
  final Logger _logger;
  final AppRemoteConfig _appRemoteConfig;
  final EnvironmentVariables _environmentVariables;

  DotagiftxRemoteConfigImpl(
    this._logger,
    this._appRemoteConfig,
    this._environmentVariables,
  );

  @override
  Future<String> getDotagiftxImageBaseUrl() async {
    final dotagiftxImageBaseUrl = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyDotagiftxImageBaseUrl,
    );

    return dotagiftxImageBaseUrl ??
        '${_environmentVariables.baseUrl}${RemoteConfigConstants.defaultDotagiftxImageEndpoint}';
  }

  @override
  Future<Iterable<HeroModel>> getHeroes() async {
    final heroesString = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyHeroes,
    );

    if (!StringUtils.isNullOrEmpty(heroesString)) {
      try {
        final heroesJson = jsonDecode(heroesString!) as List<dynamic>;
        return heroesJson
            .map((e) => e as Map<String, dynamic>)
            .map(HeroModel.fromJson);
      } catch (e, st) {
        _logger.log(
          LogLevel.error,
          'Error parsing heroes from remote config',
          e,
          st,
        );

        return _getDefaultHeroes();
      }
    }

    return _getDefaultHeroes();
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
      } catch (e, st) {
        _logger.log(
          LogLevel.error,
          'Error parsing roadmap from remote config',
          e,
          st,
        );
        return RemoteConfigConstants.defaultRoadmap;
      }
    }

    return RemoteConfigConstants.defaultRoadmap;
  }

  @override
  Future<ThemeModel> getTheme() async {
    final themeString = await _appRemoteConfig.tryGetData<String>(
      RemoteConfigConstants.keyTheme,
    );

    if (!StringUtils.isNullOrEmpty(themeString)) {
      try {
        final themeJson = jsonDecode(themeString!) as Map<String, dynamic>;
        return ThemeModel.fromJson(themeJson);
      } catch (e, st) {
        _logger.log(
          LogLevel.error,
          'Error parsing theme from remote config',
          e,
          st,
        );

        return RemoteConfigConstants.defaultTheme;
      }
    }

    return RemoteConfigConstants.defaultTheme;
  }

  @override
  Future<int> getTokenRotationSeconds() async {
    final tokenRotationSeconds = await _appRemoteConfig.tryGetData<int>(
      RemoteConfigConstants.keyTokenRotationSeconds,
    );

    return (tokenRotationSeconds ?? 0) != 0
        ? tokenRotationSeconds!
        : RemoteConfigConstants.defaultTokenRotationSeconds;
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
      } catch (e, st) {
        _logger.log(
          LogLevel.error,
          'Error parsing treasures from remote config',
          e,
          st,
        );
        return RemoteConfigConstants.defaultTreasures;
      }
    }

    return RemoteConfigConstants.defaultTreasures;
  }

  Future<Iterable<HeroModel>> _getDefaultHeroes() async {
    final heroesString = await rootBundle.loadString(Assets.json.heroes);
    final heroesJson = jsonDecode(heroesString) as List<dynamic>;
    return heroesJson.map((e) => HeroModel.fromJson(e as Map<String, dynamic>));
  }
}
