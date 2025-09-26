import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dota_item_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class DotaItemModel extends Equatable {
  final String id;
  final String? name;
  final String? hero;
  final String? image;
  final String? rarity;
  final String? slug;
  final double? lowestAsk;
  final double? highestBid;
  final String? origin;
  final int? reservedCount;
  final int? soldCount;
  final int? bidCount;

  const DotaItemModel({
    required this.id,
    this.name,
    this.hero,
    this.image,
    this.rarity,
    this.slug,
    this.lowestAsk,
    this.highestBid,
    this.origin,
    this.reservedCount,
    this.soldCount,
    this.bidCount,
  });

  factory DotaItemModel.fromJson(Map<String, dynamic> json) =>
      _$DotaItemModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    name,
    hero,
    rarity,
    image,
    slug,
    lowestAsk,
    highestBid,
    origin,
    reservedCount,
    soldCount,
    bidCount,
  ];

  Map<String, dynamic> toJson() => _$DotaItemModelToJson(this);
}
