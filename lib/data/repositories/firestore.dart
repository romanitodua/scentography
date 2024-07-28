import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scentography/features/forum/models/comment.dart';
import 'package:scentography/features/forum/models/forum_post.dart';

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

  Future<List<Fragrance>> getTrendingFragrances(String collectionPath) async {
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

  Future<List<ForumPost>> getForumPosts(String collectionPath,
      {DocumentSnapshot? startAfter, int limit = 10}) async {
    Query query = db
        .collection(collectionPath)
        .orderBy(FieldPath.documentId)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    QuerySnapshot snapshot = await query.get();
    List<ForumPost> posts =
        snapshot.docs.map((doc) => ForumPost.fromFirestore(doc)).toList();
    return posts;
  }

  Stream<List<Comment>> getCommentsByPostId(User? user, String postId) {
    DocumentReference reference = db.collection("posts").doc(postId);
    return db
        .collection('comments')
        .where('post_id', isEqualTo: reference).orderBy('date',descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromFirestore(doc, user))
            .toList());
  }

  Future<bool> addComment(User user, String postId, String content) async {
    bool delivered = false;
    final docData = {
      "author_name": user.displayName,
      "content": content,
      "date": DateTime.now(),
      "like_count": 0,
      "post_id": db.collection("posts").doc(postId),
      "likes": List<String>.empty(growable: false),
    };
    try {
      await db.collection("comments").add(docData);
      delivered = true;
    } catch (e) {
      print("Error adding comment: $e");
      delivered = false;
    } finally {
      print("completed");
    }
    return delivered;
  }
}
