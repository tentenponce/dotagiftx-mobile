import 'dart:async';
import 'dart:convert';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SharedPreferenceStorage {
  Future<bool> clear(String key);

  Future<Iterable<String>> getKeysWithPrefix(String prefix);

  Future<T?> getValue<T>(String key);

  Future<Iterable<T>> getValues<T>(String key);

  Stream<(String, Object?)> listen(String key);

  Future<bool> setValue(String key, Object value);
}

@LazySingleton(as: SharedPreferenceStorage)
class SharedPreferenceStorageImpl implements SharedPreferenceStorage {
  final Logger _logger;
  SharedPreferences? _prefs;

  final StreamController<(String, Object?)> _streamController =
      StreamController<(String, Object?)>.broadcast();

  SharedPreferenceStorageImpl(this._logger) {
    _logger.logFor(this);
  }

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.reload();

    return _prefs!;
  }

  @override
  Future<bool> clear(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final result = await (await prefs).remove(key);

    if (result) {
      _streamController.add((key, null));
    }

    return result;
  }

  @override
  Future<Iterable<String>> getKeysWithPrefix(String prefix) async {
    final keys = (await prefs).getKeys();

    return keys.where((key) => key.startsWith(prefix));
  }

  @override
  Future<T?> getValue<T>(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final value = (await prefs).get(key);

    return value as T?;
  }

  @override
  Future<Iterable<T>> getValues<T>(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    final stringValue = (await prefs).getString(key);

    if (stringValue == null) {
      return [];
    }

    final values = jsonDecode(stringValue) as List<dynamic>;
    return values.cast();
  }

  @override
  Stream<(String, Object?)> listen(String key) {
    return _streamController.stream.where((event) => event.$1 == key);
  }

  @override
  Future<bool> setValue(String key, Object value) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    var result = false;

    if (value is String) {
      result = await (await prefs).setString(key, value);
    } else if (value is int) {
      result = await (await prefs).setInt(key, value);
    } else if (value is double) {
      result = await (await prefs).setDouble(key, value);
    } else if (value is bool) {
      result = await (await prefs).setBool(key, value);
    } else if (value is List<String>) {
      result = await (await prefs).setStringList(key, value);
    } else {
      _logger.log(
        LogLevel.warning,
        '${value.runtimeType} not supported, implicitly saving as string',
      );

      result = await (await prefs).setString(key, value.toString());
    }

    if (result) {
      _streamController.add((key, value));
    }

    return result;
  }
}
