import 'dart:convert';

import 'package:async/async.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class ListenLocalStorage {
  Stream<UserModel?> listenUser();
}

@LazySingleton(as: ListenLocalStorage)
class ListenLocalStorageImpl implements ListenLocalStorage {
  final SharedPreferenceStorage _sharedPreferenceStorage;

  ListenLocalStorageImpl(this._sharedPreferenceStorage);

  Future<UserModel?> getUserFromCache() async {
    final userAsString = await _sharedPreferenceStorage.getValue<String>(
      SharedPreferencesKeys.user,
    );

    if (!StringUtils.isNullOrEmpty(userAsString)) {
      return UserModel.fromJson(
        jsonDecode(userAsString!) as Map<String, dynamic>,
      );
    }

    return null;
  }

  @override
  Stream<UserModel?> listenUser() {
    return StreamGroup.merge([
      // ignore: discarded_futures
      Stream.fromFuture(getUserFromCache()),
      _sharedPreferenceStorage.listen(SharedPreferencesKeys.user).map((event) {
        final user = event.$2;

        if (user != null) {
          return UserModel.fromJson(
            jsonDecode(user as String) as Map<String, dynamic>,
          );
        }

        return null;
      }),
    ]);
  }
}
