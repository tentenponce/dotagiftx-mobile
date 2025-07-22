import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketStats extends Equatable {
  final int live; // items
  final int reserved; // reserved
  final int sold; // delivered
  final int bidCompleted; // bought

  const MarketStats({
    required this.live,
    required this.reserved,
    required this.sold,
    required this.bidCompleted,
  });

  factory MarketStats.fromJson(Map<String, dynamic> json) =>
      _$MarketStatsFromJson(json);

  @override
  List<Object?> get props => [live, reserved, sold, bidCompleted];

  Map<String, dynamic> toJson() => _$MarketStatsToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String? name;
  final String? url;
  final String? avatar;
  final String? createdAt;
  final MarketStats marketStats;
  final int? subscription;
  final String? subscribedAt;

  const UserModel({
    required this.name,
    required this.url,
    required this.avatar,
    required this.createdAt,
    required this.marketStats,
    required this.subscription,
    required this.subscribedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
    name,
    url,
    createdAt,
    marketStats,
    subscription,
    subscribedAt,
  ];

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
