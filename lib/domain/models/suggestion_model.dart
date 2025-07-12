import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestion_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class SuggestionModel extends Equatable {
  final String? userId;
  final String? comment;

  const SuggestionModel({this.userId, this.comment});

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);

  @override
  List<Object?> get props => [userId, comment];

  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);
}
