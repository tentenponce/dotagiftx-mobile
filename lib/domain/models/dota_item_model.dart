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
  final double? lowestAsk;
  final String? origin;
  final int? reservedCount;
  final int? soldCount;

  const DotaItemModel({
    required this.id,
    this.name,
    this.hero,
    this.image,
    this.rarity,
    this.lowestAsk,
    this.origin,
    this.reservedCount,
    this.soldCount,
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
    lowestAsk,
    origin,
    reservedCount,
    soldCount,
  ];

  Map<String, dynamic> toJson() => _$DotaItemModelToJson(this);
}
