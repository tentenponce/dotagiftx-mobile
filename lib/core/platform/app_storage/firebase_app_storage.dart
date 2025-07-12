import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/platform/app_storage/app_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppStorage)
class FirebaseAppStorage implements AppStorage {
  final Logger _logger;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAppStorage(this._logger);

  @override
  Future<String> write(
    String collectionName,
    Map<String, dynamic> data, {
    String? docId,
  }) async {
    _logger.log(
      LogLevel.info,
      'Writing to collection: $collectionName with data: $data',
    );

    final collection = _firestore.collection(collectionName);
    DocumentReference docRef;

    if (docId != null) {
      docRef = collection.doc(docId);
      await docRef.set(data);
    } else {
      docRef = await collection.add(data);
    }

    return docRef.id;
  }
}
