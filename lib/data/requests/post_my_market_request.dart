import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_my_market_request.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class PostMyMarketRequest extends Equatable {
  final String itemId;
  final String notes;
  final double price;

  const PostMyMarketRequest({
    required this.itemId,
    required this.price,
    required this.notes,
  });

  factory PostMyMarketRequest.fromJson(Map<String, dynamic> json) =>
      _$PostMyMarketRequestFromJson(json);

  @override
  List<Object?> get props => [itemId, price, notes];

  Map<String, dynamic> toJson() => _$PostMyMarketRequestToJson(this);
}
