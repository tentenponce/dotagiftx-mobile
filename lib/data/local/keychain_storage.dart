import 'dart:async';

import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract interface class KeychainStorage {
  Future<void> add(String key, String value);

  Future<void> clear(String key);

  Future<void> clearAll();

  Future<String?> getValue(String key);
}

@LazySingleton(as: KeychainStorage)
class KeychainStorageImpl implements KeychainStorage {
  final _secureStorage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<void> add(String key, String value) {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');
    assert(!StringUtils.isNullOrEmpty(value), 'Key cannot be null or empty');

    return _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> clear(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    // Workaround for the issue where the plugin throws an exception when the key is not found on iOS
    // See https://github.com/mogol/flutter_secure_storage/issues/709
    try {
      await _secureStorage.delete(key: key);
    } on PlatformException catch (e) {
      // Specifically for iOS, if the key is not found, skip the error.
      if (e.message?.contains(
            'The specified item could not be found in the keychain',
          ) ??
          false) {
        return;
      }

      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    // Explicitly pass keys needed to be cleared. This is just in case not all keys are cleared (for iOS).
    await Future.wait(KeychainKeys.allKeys.map(clear));
  }

  @override
  Future<String?> getValue(String key) async {
    assert(!StringUtils.isNullOrEmpty(key), 'Key cannot be null or empty');

    // Workaround for the issue where the plugin throws an exception when the key is not found on iOS
    // See https://github.com/mogol/flutter_secure_storage/issues/709
    try {
      final value = await _secureStorage.read(key: key);
      return value;
    } on PlatformException catch (e) {
      // Specifically for iOS, if the key is not found, return null.
      if (e.message?.contains(
            'The specified item could not be found in the keychain',
          ) ??
          false) {
        return null;
      }

      rethrow;
    }
  }
}
