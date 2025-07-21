import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshTokenRequest extends Equatable {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  @override
  List<Object?> get props => [refreshToken];

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
