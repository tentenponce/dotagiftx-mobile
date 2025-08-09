import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshTokenResponse extends Equatable {
  final String token;
  final String expiresAt;

  const RefreshTokenResponse({required this.token, required this.expiresAt});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  @override
  List<Object?> get props => [token, expiresAt];

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}
