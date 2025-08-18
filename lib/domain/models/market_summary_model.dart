import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_summary_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketSummaryModel extends Equatable {
  final int? reservedListings;
  final int? deliveredListings;
  final int? toReceiveOrders;
  final int? completedOrders;

  const MarketSummaryModel({
    this.reservedListings,
    this.deliveredListings,
    this.toReceiveOrders,
    this.completedOrders,
  });

  factory MarketSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MarketSummaryModelFromJson(json);

  @override
  List<Object?> get props => [
    reservedListings,
    deliveredListings,
    toReceiveOrders,
    completedOrders,
  ];

  Map<String, dynamic> toJson() => _$MarketSummaryModelToJson(this);
}
