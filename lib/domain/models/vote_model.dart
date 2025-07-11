import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vote_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class VoteModel extends Equatable {
  final String? userId;
  final String? featureId;

  const VoteModel({this.userId, this.featureId});

  factory VoteModel.fromJson(Map<String, dynamic> json) =>
      _$VoteModelFromJson(json);

  @override
  List<Object?> get props => [userId, featureId];

  Map<String, dynamic> toJson() => _$VoteModelToJson(this);
}
