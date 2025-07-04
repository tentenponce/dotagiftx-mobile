import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treasure_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class TreasureItem extends Equatable {
  final String name;
  final String image;
  final String rarity;

  const TreasureItem({
    required this.name,
    required this.image,
    required this.rarity,
  });

  factory TreasureItem.fromJson(Map<String, dynamic> json) =>
      _$TreasureItemFromJson(json);

  @override
  List<Object?> get props => [name, image, rarity];

  Map<String, dynamic> toJson() => _$TreasureItemToJson(this);
}
