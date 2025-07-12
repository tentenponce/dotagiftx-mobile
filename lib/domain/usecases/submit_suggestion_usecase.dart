import 'package:dotagiftx_mobile/data/platform/dotagiftx_storage.dart';
import 'package:injectable/injectable.dart';

abstract interface class SubmitSuggestionUsecase {
  Future<void> submit(String suggestion);
}

@LazySingleton(as: SubmitSuggestionUsecase)
class SubmitSuggestionUsecaseImpl implements SubmitSuggestionUsecase {
  final DotagiftxStorage _dotagiftxStorage;

  SubmitSuggestionUsecaseImpl(this._dotagiftxStorage);

  @override
  Future<void> submit(String suggestion) async {
    await _dotagiftxStorage.submitSuggestion(suggestion);
  }
}
