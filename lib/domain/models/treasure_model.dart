import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treasure_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class TreasureModel extends Equatable {
  final String? name;
  final String? image;
  final String? rarity;
  final String? imageUrl;

  const TreasureModel({this.name, this.image, this.rarity, this.imageUrl});

  factory TreasureModel.fromJson(Map<String, dynamic> json) =>
      _$TreasureModelFromJson(json);

  @override
  List<Object?> get props => [name, image, rarity, imageUrl];

  Map<String, dynamic> toJson() => _$TreasureModelToJson(this);
}
