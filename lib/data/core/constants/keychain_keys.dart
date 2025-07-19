abstract final class KeychainKeys {
  static const String userId = 'userId';
  static const String steamId = 'steamId';
  static const String refreshToken = 'refreshToken';
  static const String token = 'token';
  static const String expiresAt = 'expiresAt';

  static const Iterable<String> allKeys = [
    userId,
    steamId,
    refreshToken,
    token,
    expiresAt,
  ];
}
