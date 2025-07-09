import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/steam_user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_listing_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketListingModel extends Equatable {
  final String id;
  final double? price;
  final String? createdAt;
  final int? inventoryStatus;
  final SteamUserModel? user;
  final bool? resell;

  const MarketListingModel({
    required this.id,
    required this.inventoryStatus,
    required this.user,
    this.price,
    this.createdAt,
    this.resell,
  });

  factory MarketListingModel.fromJson(Map<String, dynamic> json) =>
      _$MarketListingModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    price,
    createdAt,
    inventoryStatus,
    user,
    resell,
  ];

  Map<String, dynamic> toJson() => _$MarketListingModelToJson(this);
}
