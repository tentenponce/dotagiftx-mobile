import 'package:freezed_annotation/freezed_annotation.dart';

part 'dota_item_detail_state.freezed.dart';

@freezed
abstract class DotaItemDetailState with _$DotaItemDetailState {
  const factory DotaItemDetailState({
    @Default(MarketTab.offers) MarketTab tab,
  }) = _DotaItemDetailState;
}

enum MarketTab { offers, buyOrders }
