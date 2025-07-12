import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotagiftx_mobile/core/platform/app_storage/app_storage.dart';
import 'package:dotagiftx_mobile/data/core/constants/keychain_keys.dart';
import 'package:dotagiftx_mobile/data/core/constants/storage_constants.dart';
import 'package:dotagiftx_mobile/data/local/keychain_storage.dart';
import 'package:dotagiftx_mobile/domain/models/suggestion_model.dart';
import 'package:dotagiftx_mobile/domain/models/vote_model.dart';
import 'package:injectable/injectable.dart';

abstract interface class DotagiftxStorage {
  Future<void> submitSuggestion(String comment);

  Future<void> submitVote(String featureId);
}

@LazySingleton(as: DotagiftxStorage)
class DotagiftxStorageImpl implements DotagiftxStorage {
  final AppStorage _appStorage;
  final KeychainStorage _keychainStorage;

  DotagiftxStorageImpl(this._appStorage, this._keychainStorage);

  @override
  Future<void> submitSuggestion(String comment) async {
    final userId = await _keychainStorage.getValue(KeychainKeys.userId);

    final suggestion = SuggestionModel(userId: userId, comment: comment);

    final timestamp = FieldValue.serverTimestamp();
    final suggestionWithTimestamp =
        suggestion.toJson()..['timestamp'] = timestamp;

    await _appStorage.write(
      StorageConstants.collectionSuggestions,
      suggestionWithTimestamp,
      docId: userId,
    );
  }

  @override
  Future<void> submitVote(String featureId) async {
    final userId = await _keychainStorage.getValue(KeychainKeys.userId);

    final vote = VoteModel(userId: userId, featureId: featureId);

    final timestamp = FieldValue.serverTimestamp();
    final voteWithTimestamp = vote.toJson()..['timestamp'] = timestamp;

    await _appStorage.write(
      StorageConstants.collectionVotes,
      voteWithTimestamp,
      docId: '$userId-$featureId',
    );
  }
}
