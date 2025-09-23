import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/requests/post_my_market_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class PostListingUsecase {
  Future<void> post({
    required String itemId,
    required double price,
    required String notes,
    required int quantity,
  });
}

@LazySingleton(as: PostListingUsecase)
class PostListingUsecaseImpl implements PostListingUsecase {
  final DotagiftxAuthApi _dotagiftxAuthApi;

  PostListingUsecaseImpl(this._dotagiftxAuthApi);

  @override
  Future<void> post({
    required String itemId,
    required double price,
    required String notes,
    required int quantity,
  }) async {
    // API doesn't support bulk posting, so we need to post one by one
    for (var i = 0; i < quantity; i++) {
      await _dotagiftxAuthApi.postMyMarket(
        PostMyMarketRequest(itemId: itemId, price: price, notes: notes),
      );
    }
  }
}
