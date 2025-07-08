import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/dota_item_detail/viewmodels/offers_list_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotaItemDetailCubit extends BaseCubit<void> with CubitErrorMixin<void> {
  final OffersListCubit offersListCubit;

  final Logger _logger;

  String? _itemId;

  DotaItemDetailCubit(this.offersListCubit, this._logger) : super(null) {
    _logger.logFor(this);
  }

  @override
  Logger get logger => _logger;

  @override
  Future<void> init() async {}

  Future<void> loadMoreOffers() async {
    if (StringUtils.isNullOrEmpty(_itemId)) {
      _logger.log(LogLevel.error, 'loadMoreOffers > Item ID is null or empty');
      return;
    }

    unawaited(offersListCubit.loadMoreOffers(_itemId!));
  }

  void onSwipeToRefresh() {
    if (StringUtils.isNullOrEmpty(_itemId)) {
      _logger.log(
        LogLevel.error,
        'onSwipeToRefresh > Item ID is null or empty',
      );
      return;
    }

    unawaited(offersListCubit.getNewOffers(_itemId!));
  }

  void setItemId(String? value) {
    _itemId = value;

    if (StringUtils.isNullOrEmpty(_itemId)) {
      _logger.log(LogLevel.error, 'setItemId > Item ID is null or empty');
      return;
    }

    unawaited(offersListCubit.getNewOffers(_itemId!));
  }
}
