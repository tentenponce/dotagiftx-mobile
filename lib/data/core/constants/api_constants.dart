abstract final class ApiConstants {
  static const String loginUrl = 'auth/steam';

  static const String querySortRecentBid = 'recent-bid';
  static const String querySortRecent = 'recent';
  static const String querySortPopular = 'popular';
  static const String querySortLowest = 'lowest';
  static const String querySortHighest = 'highest';
  static const String querySortBest = 'best';
  static const String querySortUpdatedAtDesc = 'updated_at:desc';
  static const String querySortCreatedAtDesc = 'created_at:desc';

  static const String queryIndexItemId = 'item_id';
  static const String queryIndexUserId = 'user_id';

  static const int queryMarketAsk = 10;
  static const int queryMarketBid = 20;

  static const int queryMarketStatusAll = 0;
  static const int queryMarketStatusLive = 200;
  static const int queryMarketStatusReserved = 300;
  static const int queryMarketStatusSold = 400; // delivered
  static const int queryMarketStatusCompleted = 410; // completed
  static const int queryMarketStatusOrderRemoved = 500;
  static const int queryMarketStatusCancelled = 600;

  static const int queryInventoryStatusVerified = 200;
}
