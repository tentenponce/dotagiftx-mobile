abstract interface class AppRemoteConfig {
  Future<void> init();

  Future<T?> tryGetData<T>(String key);

  Future<Map<String, String>?> getAllData();
}
