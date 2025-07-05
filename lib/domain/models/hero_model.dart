import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class HeroModel extends Equatable {
  final String? name;
  final String? heroImage;
  final String? attributeIcon;

  const HeroModel({this.name, this.heroImage, this.attributeIcon});

  factory HeroModel.fromJson(Map<String, dynamic> json) =>
      _$HeroModelFromJson(json);

  @override
  List<Object?> get props => [name, heroImage, attributeIcon];

  Map<String, dynamic> toJson() => _$HeroModelToJson(this);
}
