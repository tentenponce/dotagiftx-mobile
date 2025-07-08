import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_listing_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketListingResponse extends Equatable {
  final List<MarketListingModel> data;
  final int totalCount;

  const MarketListingResponse({required this.data, required this.totalCount});

  factory MarketListingResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketListingResponseFromJson(json);

  @override
  List<Object?> get props => [data];

  Map<String, dynamic> toJson() => _$MarketListingResponseToJson(this);
}
