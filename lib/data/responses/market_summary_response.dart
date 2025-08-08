import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_summary_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketSummaryResponse extends Equatable {
  final int? live; // listing - active listings
  final int? reserved; // both listing and orders - reserved, to receive
  final int? sold; // listing - delivered
  final int? bidCompleted; // order - completed

  const MarketSummaryResponse({
    this.live,
    this.reserved,
    this.sold,
    this.bidCompleted,
  });

  factory MarketSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketSummaryResponseFromJson(json);

  @override
  List<Object?> get props => [live, reserved, sold, bidCompleted];

  Map<String, dynamic> toJson() => _$MarketSummaryResponseToJson(this);
}
