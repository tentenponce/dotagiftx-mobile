import 'dart:async';

import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_storage.dart';
import 'package:injectable/injectable.dart';

abstract interface class SubmitVoteUsecase {
  Future<void> vote(String featureId);
}

@LazySingleton(as: SubmitVoteUsecase)
class SubmitVoteUsecaseImpl implements SubmitVoteUsecase {
  final DotagiftxStorage _dotagiftxStorage;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  SubmitVoteUsecaseImpl(this._dotagiftxStorage, this._sharedPreferenceStorage);

  @override
  Future<void> vote(String featureId) async {
    await _sharedPreferenceStorage.setValue(
      SharedPreferencesKeys.votes + featureId,
      true,
    );
    unawaited(_dotagiftxStorage.submitVote(featureId));
  }
}
