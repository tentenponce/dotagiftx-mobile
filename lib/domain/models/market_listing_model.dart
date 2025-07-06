import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_listing_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class InventoryModel extends Equatable {
  final String id;
  final String marketId;
  final int status;
  final List<SteamAssetModel> steamAssets;
  final int retries;
  final int bundleCount;
  final String verifiedBy;
  final int elapsedMs;
  final String createdAt;
  final String updatedAt;

  const InventoryModel({
    required this.id,
    required this.marketId,
    required this.status,
    required this.steamAssets,
    required this.retries,
    required this.bundleCount,
    required this.verifiedBy,
    required this.elapsedMs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    marketId,
    status,
    steamAssets,
    retries,
    bundleCount,
    verifiedBy,
    elapsedMs,
    createdAt,
    updatedAt,
  ];

  Map<String, dynamic> toJson() => _$InventoryModelToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketListingModel extends Equatable {
  final String id;
  final String userId;
  final String itemId;
  final int type;
  final int status;
  final double price;
  final String currency;
  final String partnerSteamId;
  final String notes;
  final String createdAt;
  final String updatedAt;
  final int inventoryStatus;
  final int deliveryStatus;
  final UserModel user;
  final DotaItemModel item;
  final InventoryModel? inventory;
  final dynamic resell;
  final String sellerSteamId;
  final int userRankScore;

  const MarketListingModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.type,
    required this.status,
    required this.price,
    required this.currency,
    required this.partnerSteamId,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.inventoryStatus,
    required this.deliveryStatus,
    required this.user,
    required this.item,
    required this.inventory,
    required this.sellerSteamId,
    required this.userRankScore,
    this.resell,
  });

  factory MarketListingModel.fromJson(Map<String, dynamic> json) =>
      _$MarketListingModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    userId,
    itemId,
    type,
    status,
    price,
    currency,
    partnerSteamId,
    notes,
    createdAt,
    updatedAt,
    inventoryStatus,
    deliveryStatus,
    user,
    item,
    inventory,
    resell,
    sellerSteamId,
    userRankScore,
  ];

  Map<String, dynamic> toJson() => _$MarketListingModelToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class MarketStatsModel extends Equatable {
  final int pending;
  final int live;
  final int reserved;
  final int sold;
  final int removed;
  final int cancelled;
  final int bidLive;
  final int bidCompleted;
  final int deliveryNoHit;
  final int deliveryNameVerified;
  final int deliverySenderVerified;
  final int deliveryPrivate;
  final int deliveryError;
  final int inventoryNoHit;
  final int inventoryVerified;
  final int inventoryPrivate;
  final int inventoryError;
  final int resellLive;
  final int resellReserved;
  final int resellSold;
  final int resellRemoved;
  final int resellCancelled;

  const MarketStatsModel({
    required this.pending,
    required this.live,
    required this.reserved,
    required this.sold,
    required this.removed,
    required this.cancelled,
    required this.bidLive,
    required this.bidCompleted,
    required this.deliveryNoHit,
    required this.deliveryNameVerified,
    required this.deliverySenderVerified,
    required this.deliveryPrivate,
    required this.deliveryError,
    required this.inventoryNoHit,
    required this.inventoryVerified,
    required this.inventoryPrivate,
    required this.inventoryError,
    required this.resellLive,
    required this.resellReserved,
    required this.resellSold,
    required this.resellRemoved,
    required this.resellCancelled,
  });

  factory MarketStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MarketStatsModelFromJson(json);

  @override
  List<Object?> get props => [
    pending,
    live,
    reserved,
    sold,
    removed,
    cancelled,
    bidLive,
    bidCompleted,
    deliveryNoHit,
    deliveryNameVerified,
    deliverySenderVerified,
    deliveryPrivate,
    deliveryError,
    inventoryNoHit,
    inventoryVerified,
    inventoryPrivate,
    inventoryError,
    resellLive,
    resellReserved,
    resellSold,
    resellRemoved,
    resellCancelled,
  ];

  Map<String, dynamic> toJson() => _$MarketStatsModelToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class SteamAssetModel extends Equatable {
  final String assetId;
  final String classId;
  final String instanceId;
  final int qty;
  final String name;
  final String image;
  final String type;
  final String hero;
  final String giftFrom;
  final String contains;
  final String dateReceived;
  final String dedication;
  final bool giftOnce;
  final bool notTradable;
  final List<String> descriptions;

  const SteamAssetModel({
    required this.assetId,
    required this.classId,
    required this.instanceId,
    required this.qty,
    required this.name,
    required this.image,
    required this.type,
    required this.hero,
    required this.giftFrom,
    required this.contains,
    required this.dateReceived,
    required this.dedication,
    required this.giftOnce,
    required this.notTradable,
    required this.descriptions,
  });

  factory SteamAssetModel.fromJson(Map<String, dynamic> json) =>
      _$SteamAssetModelFromJson(json);

  @override
  List<Object?> get props => [
    assetId,
    classId,
    instanceId,
    qty,
    name,
    image,
    type,
    hero,
    giftFrom,
    contains,
    dateReceived,
    dedication,
    giftOnce,
    notTradable,
    descriptions,
  ];

  Map<String, dynamic> toJson() => _$SteamAssetModelToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String id;
  final String steamId;
  final String name;
  final String url;
  final String avatar;
  final int status;
  final String notes;
  final int donation;
  final String? donatedAt;
  final String createdAt;
  final String updatedAt;
  final MarketStatsModel marketStats;
  final int rankScore;
  final int subscription;
  final String? subscribedAt;
  final String subscriptionType;
  final String? subscriptionEndsAt;
  final dynamic boons;
  final bool hammer;

  const UserModel({
    required this.id,
    required this.steamId,
    required this.name,
    required this.url,
    required this.avatar,
    required this.status,
    required this.notes,
    required this.donation,
    required this.createdAt,
    required this.updatedAt,
    required this.marketStats,
    required this.rankScore,
    required this.subscription,
    required this.subscriptionType,
    required this.hammer,
    this.donatedAt,
    this.subscribedAt,
    this.subscriptionEndsAt,
    this.boons,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    steamId,
    name,
    url,
    avatar,
    status,
    notes,
    donation,
    donatedAt,
    createdAt,
    updatedAt,
    marketStats,
    rankScore,
    subscription,
    subscribedAt,
    subscriptionType,
    subscriptionEndsAt,
    boons,
    hammer,
  ];

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
