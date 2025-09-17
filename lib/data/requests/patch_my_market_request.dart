import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patch_my_market_request.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class PatchMyMarketRequest extends Equatable {
  final int? status;
  final String? partnerSteamId;
  final String? notes;

  const PatchMyMarketRequest({this.status, this.partnerSteamId, this.notes});

  factory PatchMyMarketRequest.fromJson(Map<String, dynamic> json) =>
      _$PatchMyMarketRequestFromJson(json);

  @override
  List<Object?> get props => [status, partnerSteamId, notes];

  Map<String, dynamic> toJson() => _$PatchMyMarketRequestToJson(this);
}
