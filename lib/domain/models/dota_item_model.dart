import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dota_item_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class DotaItemModel extends Equatable {
  final String id;
  final String name;
  final String hero;
  final String image;
  final String rarity;
  final double lowestAsk;

  const DotaItemModel({
    required this.id,
    required this.name,
    required this.hero,
    required this.image,
    required this.rarity,
    required this.lowestAsk,
  });

  factory DotaItemModel.fromJson(Map<String, dynamic> json) =>
      _$DotaItemModelFromJson(json);

  @override
  List<Object?> get props => [id, name, hero, rarity, image, lowestAsk];

  Map<String, dynamic> toJson() => _$DotaItemModelToJson(this);
}
