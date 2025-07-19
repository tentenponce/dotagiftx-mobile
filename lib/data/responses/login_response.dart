import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse extends Equatable {
  final String userId;
  final String steamId;
  final String refreshToken;
  final String token;
  final String expiresAt;

  const LoginResponse({
    required this.userId,
    required this.steamId,
    required this.refreshToken,
    required this.token,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  @override
  List<Object?> get props => [userId, steamId, refreshToken, token, expiresAt];

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
