import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/models/fragrance.dart';

class FireStoreRepo {
  FirebaseFirestore db;

  FireStoreRepo._privateConstructor() : db = FirebaseFirestore.instance;

  static final FireStoreRepo _instance = FireStoreRepo._privateConstructor();

  factory FireStoreRepo() {
    return _instance;
  }

  Future<Fragrance> getFragranceById(
      String collectionPath, String documentId) async {
    DocumentSnapshot doc =
        await db.collection(collectionPath).doc(documentId).get();
    return Fragrance.fromFirestore(doc);
  }

  Future<List<Fragrance>> getTrendingFragrances(
      String collectionPath) async {
    List<Fragrance> result = [];
    QuerySnapshot snapshot =
        await db.collection(collectionPath).orderBy(FieldPath.documentId).get();
    for (final e in snapshot.docs) {
      result.add(Fragrance.fromFirestore(e));
    }
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);
    result.add(result[0]);

    return result;
  }
}
