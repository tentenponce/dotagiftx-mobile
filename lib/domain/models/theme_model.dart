import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'theme_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class ThemeModel extends Equatable {
  final String? seedColor;
  final String? brightness;

  const ThemeModel({this.seedColor, this.brightness});

  factory ThemeModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeModelFromJson(json);

  @override
  List<Object?> get props => [seedColor, brightness];

  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);
}
