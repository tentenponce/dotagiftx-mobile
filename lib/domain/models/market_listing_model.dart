import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
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
  final String? updatedAt;
  final int? inventoryStatus;
  final SteamUserModel? user;
  final DotaItemModel? item;
  final bool? resell;
  final String? notes;
  final String? partnerSteamId;

  const MarketListingModel({
    required this.id,
    required this.inventoryStatus,
    required this.user,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.resell,
    this.item,
    this.notes,
    this.partnerSteamId,
  });

  factory MarketListingModel.fromJson(Map<String, dynamic> json) =>
      _$MarketListingModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    price,
    createdAt,
    updatedAt,
    inventoryStatus,
    user,
    resell,
    item,
    notes,
    partnerSteamId,
  ];

  Map<String, dynamic> toJson() => _$MarketListingModelToJson(this);
}
