import 'package:dotagiftx_mobile/data/api/dotagiftx_auth_api.dart';
import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/data/requests/post_my_market_request.dart';
import 'package:dotagiftx_mobile/domain/core/domain_exceptions.dart';
import 'package:injectable/injectable.dart';

abstract interface class PostListingUsecase {
  Future<void> post({
    required String itemId,
    required double price,
    String? notes,
    int? quantity,
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
    String? notes,
    int? quantity,
  }) async {
    quantity = quantity ?? 1;
    notes = notes ?? '';

    if (quantity <= 0) {
      throw InvalidQuantityException();
    }

    // API doesn't support bulk posting, so we need to post one by one
    for (var i = 0; i < quantity; i++) {
      await _dotagiftxAuthApi.postMyMarket(
        PostMyMarketRequest(
          itemId: itemId,
          price: price,
          notes: notes,
          type: ApiConstants.queryMarketAsk,
        ),
      );
    }
  }
}
