import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'roadmap_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class RoadmapModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isCompleted;
  final bool isActive;
  final bool? isVoted;

  const RoadmapModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
    this.isVoted,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    icon,
    isCompleted,
    isActive,
    isVoted,
  ];

  Map<String, dynamic> toJson() => _$RoadmapModelToJson(this);
}
