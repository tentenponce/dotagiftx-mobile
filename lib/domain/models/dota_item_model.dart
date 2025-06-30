import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dota_item_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class DotaItemModel extends Equatable {
  final String id;
  final String slug;
  final String name;
  final String hero;
  final String image;
  final String origin;
  final String rarity;
  final int viewCount;
  final int quantity;
  final int lowestAsk;
  final int medianAsk;
  final DateTime? recentAsk;
  final int highestBid;
  final DateTime? recentBid;
  final int bidCount;
  final int reservedCount;
  final int soldCount;
  final int saleCount;
  final double avgSale;
  final DateTime? recentSale;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic asks;
  final dynamic bids;

  const DotaItemModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.hero,
    required this.image,
    required this.origin,
    required this.rarity,
    required this.viewCount,
    required this.quantity,
    required this.lowestAsk,
    required this.medianAsk,
    this.recentAsk,
    required this.highestBid,
    this.recentBid,
    required this.bidCount,
    required this.reservedCount,
    required this.soldCount,
    required this.saleCount,
    required this.avgSale,
    this.recentSale,
    required this.createdAt,
    required this.updatedAt,
    this.asks,
    this.bids,
  });

  factory DotaItemModel.fromJson(Map<String, dynamic> json) =>
      _$DotaItemModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    slug,
    name,
    hero,
    image,
    origin,
    rarity,
    viewCount,
    quantity,
    lowestAsk,
    medianAsk,
    recentAsk,
    highestBid,
    recentBid,
    bidCount,
    reservedCount,
    soldCount,
    saleCount,
    avgSale,
    recentSale,
    createdAt,
    updatedAt,
    asks,
    bids,
  ];

  Map<String, dynamic> toJson() => _$DotaItemModelToJson(this);
}
