import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'steam_user_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class SteamUserMarketStatsModel extends Equatable {
  final int? live;
  final int? reserved;
  final int? sold;
  final int? bidCompleted;

  const SteamUserMarketStatsModel({
    this.live,
    this.reserved,
    this.sold,
    this.bidCompleted,
  });

  factory SteamUserMarketStatsModel.fromJson(Map<String, dynamic> json) =>
      _$SteamUserMarketStatsModelFromJson(json);

  @override
  List<Object?> get props => [live, reserved, sold, bidCompleted];

  Map<String, dynamic> toJson() => _$SteamUserMarketStatsModelToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class SteamUserModel extends Equatable {
  final String id;
  final String? steamId;
  final String? name;
  final String? url;
  final String? avatar;
  final int? subscription;
  final SteamUserMarketStatsModel? marketStats;
  final String? createdAt;

  const SteamUserModel({
    required this.id,
    this.subscription,
    this.steamId,
    this.name,
    this.url,
    this.avatar,
    this.marketStats,
    this.createdAt,
  });

  factory SteamUserModel.fromJson(Map<String, dynamic> json) =>
      _$SteamUserModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    subscription,
    name,
    avatar,
    steamId,
    url,
    marketStats,
    createdAt,
  ];

  Map<String, dynamic> toJson() => _$SteamUserModelToJson(this);
}
