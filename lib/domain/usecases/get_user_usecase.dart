import 'dart:async';
import 'dart:convert';

import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetUserUsecase {
  Future<UserModel> call();
}

@LazySingleton(as: GetUserUsecase)
class GetUserUsecaseImpl implements GetUserUsecase {
  final DotagiftxAuthApi _dotagiftxApi;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  GetUserUsecaseImpl(this._dotagiftxApi, this._sharedPreferenceStorage);

  @override
  Future<UserModel> call() async {
    final userResponse = await _dotagiftxApi.getUser();

    unawaited(
      _sharedPreferenceStorage.setValue(
        SharedPreferencesKeys.user,
        jsonEncode(userResponse.toJson()),
      ),
    );

    return userResponse;
  }
}
