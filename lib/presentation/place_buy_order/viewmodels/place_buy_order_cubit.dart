import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/data/local/listen_local_storage.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/domain/usecases/place_buy_order_usecase.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/states/place_buy_order_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlaceBuyOrderCubit extends BaseCubit<PlaceBuyOrderState>
    with CubitErrorMixin<PlaceBuyOrderState> {
  late final void Function() showSuccessOrder;

  DotaItemModel? selectedItem;
  String notes = '';

  final Logger _logger;
  final PlaceBuyOrderUsecase _placeBuyOrderUsecase;
  final ListenLocalStorage _listenLocalStorage;

  String _price = '';

  PlaceBuyOrderCubit(
    this._logger,
    this._placeBuyOrderUsecase,
    this._listenLocalStorage,
  ) : super(const PlaceBuyOrderState());

  @override
  Logger get logger => _logger;

  String get price => _price;
  set price(String value) {
    emit(state.copyWith(isPriceErrorRequired: value.isEmpty));
    _price = value;
  }

  @override
  Future<void> init() async {
    _listenUserIfLoggedIn();
  }

  Future<void> placeBuyOrder() async {
    final parsedPrice = double.tryParse(price) ?? 0;

    if (selectedItem == null) {
      unawaited(
        defaultErrorHandler(
          Exception('Should not happen, selected item is null'),
          stackTrace: StackTrace.current,
        ),
      );

      return;
    }

    if (parsedPrice <= 0) {
      emit(state.copyWith(isPriceErrorRequired: parsedPrice <= 0));
      return;
    }

    emit(state.copyWith(isPlaceBuyOrderLoading: true));
    await cubitHandler(
      () => _placeBuyOrderUsecase.placeBuyOrder(
        itemId: selectedItem?.id ?? '',
        price: parsedPrice,
        notes: notes,
      ),
      (response) async {
        showSuccessOrder();
      },
    );
    emit(state.copyWith(isPlaceBuyOrderLoading: false));
  }

  void _listenUserIfLoggedIn() {
    _listenLocalStorage.listenUser().listen((user) {
      emit(state.copyWith(isUserLoggedIn: user != null));
    });
  }
}
