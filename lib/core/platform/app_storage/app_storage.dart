abstract interface class AppStorage {
  Future<String> write(
    String collectionName,
    Map<String, dynamic> data, {
    String? docId,
  });
}
