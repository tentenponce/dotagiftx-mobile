import 'package:copy_with_extension/copy_with_extension.dart';
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
  final UserModel? user;
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

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String id;
  final String? name;
  final String? avatar;
  final int? subscription;

  const UserModel({
    required this.id,
    required this.subscription,
    this.name,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [id, subscription, name, avatar];

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
