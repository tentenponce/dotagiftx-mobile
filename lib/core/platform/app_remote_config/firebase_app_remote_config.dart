import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_remote_config/app_remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppRemoteConfig)
class FirebaseAppRemoteConfig implements AppRemoteConfig {
  late FirebaseRemoteConfig _firebaseRemoteConfig;
  final Logger _logger;

  FirebaseAppRemoteConfig(this._logger) {
    _logger.logFor(this);
  }

  @override
  Future<Map<String, String>?> getAllData() async {
    try {
      final allData = _firebaseRemoteConfig.getAll();
      _logger.log(LogLevel.info, 'Remote config > feature: all data $allData');

      return allData.map((key, value) => MapEntry(key, value.asString()));
    } catch (e) {
      _logger.log(
        LogLevel.error,
        'Remote config > Error getting all data of Firebase Remote Config',
        e,
      );
      return null;
    }
  }

  @override
  Future<void> init() async {
    _logger.log(LogLevel.info, 'Initializing Firebase Remote Config');
    _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

    try {
      await _firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );

      final res = await _firebaseRemoteConfig.fetchAndActivate();
      _logger.log(
        LogLevel.info,
        'Firebase remote config fetchAndActivate result: $res',
      );
    } catch (e, st) {
      _logger.log(
        LogLevel.error,
        'Error Initializing Firebase Remote Config',
        e,
        st,
      );
    }
  }

  @override
  Future<T?> tryGetData<T>(String key) async {
    final value = _getData<T>(key);
    _logger.log(
      LogLevel.info,
      'Returning data from remote config for key: $key, value: $value',
    );
    return value;
  }

  T _getData<T>(String key) {
    if (T == String) {
      return _firebaseRemoteConfig.getString(key) as T;
    } else if (T == bool) {
      return _firebaseRemoteConfig.getBool(key) as T;
    } else if (T == int) {
      return _firebaseRemoteConfig.getInt(key) as T;
    } else if (T == double) {
      return _firebaseRemoteConfig.getDouble(key) as T;
    } else {
      throw Exception('Unsupported type');
    }
  }
}
