import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'revoke_token_request.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class RevokeTokenRequest extends Equatable {
  final String refreshToken;

  const RevokeTokenRequest({required this.refreshToken});

  factory RevokeTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RevokeTokenRequestFromJson(json);

  @override
  List<Object?> get props => [refreshToken];

  Map<String, dynamic> toJson() => _$RevokeTokenRequestToJson(this);
}
