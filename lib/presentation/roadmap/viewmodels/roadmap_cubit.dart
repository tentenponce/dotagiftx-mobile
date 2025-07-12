import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/core/constants/remote_config_constants.dart';
import 'package:dotagiftx_mobile/data/platform/dotagiftx_remote_config.dart';
import 'package:dotagiftx_mobile/domain/models/roadmap_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/get_votes_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_suggestion_usecase.dart';
import 'package:dotagiftx_mobile/domain/usecases/submit_vote_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoadmapCubit extends BaseCubit<List<RoadmapModel>>
    with CubitErrorMixin<List<RoadmapModel>> {
  final Logger _logger;
  final DotagiftxRemoteConfig _dotagiftxRemoteConfig;
  final SubmitVoteUsecase _submitVoteUsecase;
  final GetVotesUsecase _getVotesUsecase;
  final SubmitSuggestionUsecase _submitSuggestionUsecase;

  RoadmapCubit(
    this._logger,
    this._dotagiftxRemoteConfig,
    this._submitVoteUsecase,
    this._getVotesUsecase,
    this._submitSuggestionUsecase,
  ) : super(RemoteConfigConstants.defaultRoadmap.toList());

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {
    await cubitHandler<List<RoadmapModel>>(
      () async {
        final roadmap = await _dotagiftxRemoteConfig.getRoadmap();
        final votes = await _getVotesUsecase.getVotes();

        return roadmap.map((roadmap) {
          return roadmap.copyWith(
            isVoted: votes.any((vote) => vote.featureId == roadmap.id),
          );
        }).toList();
      },
      (roadmap) async {
        emit(roadmap);
      },
    );
  }

  Future<void> submitSuggestion(String suggestion) async {
    await cubitHandler<void>(() async {
      await _submitSuggestionUsecase.submit(suggestion);
    }, (_) async {}); // ignore if success or error, just submit
  }

  Future<void> vote(String featureId) async {
    // optimistic update, don't wait for the result regardless if error occurs
    final roadmap =
        state.map((roadmap) {
          if (roadmap.id == featureId) {
            return roadmap.copyWith(isVoted: true);
          }
          return roadmap;
        }).toList();
    emit(roadmap);

    await cubitHandler<void>(() async {
      await _submitVoteUsecase.vote(featureId);
    }, (_) async {});
  }
}
