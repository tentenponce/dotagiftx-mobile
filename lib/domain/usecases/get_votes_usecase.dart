import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/shared_preferences_keys.dart';
import 'package:dotagiftx_mobile/data/local/shared_preference_storage.dart';
import 'package:dotagiftx_mobile/domain/models/vote_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class GetVotesUsecase {
  Future<Iterable<VoteModel>> getVotes();
}

@LazySingleton(as: GetVotesUsecase)
class GetVotesUsecaseImpl implements GetVotesUsecase {
  final Logger _logger;
  final SharedPreferenceStorage _sharedPreferenceStorage;

  GetVotesUsecaseImpl(this._logger, this._sharedPreferenceStorage);

  @override
  Future<Iterable<VoteModel>> getVotes() async {
    // TODO(dev): local storage for now, should be from remote storage if login is enabled
    final keys = await _sharedPreferenceStorage.getKeysWithPrefix(
      SharedPreferencesKeys.votes,
    );

    final votes = <VoteModel>[];

    for (final key in keys) {
      bool? vote;
      try {
        vote = await _sharedPreferenceStorage.getValue<bool>(key);
      } catch (e) {
        _logger.log(
          LogLevel.error,
          'Error getting vote for $key in local storage',
          e,
        );
      }

      if (vote ?? false) {
        votes.add(
          VoteModel(
            featureId: key.replaceFirst(SharedPreferencesKeys.votes, ''),
          ),
        );
      }
    }

    return votes;
  }
}
