import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/core/base/cubit_error_mixin.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/states/place_buy_order_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlaceBuyOrderCubit extends BaseCubit<PlaceBuyOrderState>
    with CubitErrorMixin<PlaceBuyOrderState> {
  late final void Function() showSuccessOrder;
  String notes = '';
  final Logger _logger;
  String _price = '';

  PlaceBuyOrderCubit(this._logger) : super(const PlaceBuyOrderState());

  @override
  Logger get logger => _logger;

  String get price => _price;
  set price(String value) {
    emit(state.copyWith(isPriceErrorRequired: value.isEmpty));
    _price = value;
  }

  @override
  Future<void> init() async {}

  Future<void> placeBuyOrder() async {
    emit(state.copyWith(isPlaceBuyOrderLoading: true));
    await Future<void>.delayed(const Duration(seconds: 2));
    showSuccessOrder();
    emit(state.copyWith(isPlaceBuyOrderLoading: false));
  }
}
