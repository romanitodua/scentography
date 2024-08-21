import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scentography/domain/comment.dart';
import 'package:scentography/domain/forum_post.dart';
import 'package:scentography/utils/constants/database.dart';

import '../../domain/fragrance.dart';
import '../../domain/ratings.dart';

class FireStoreRepo {
  FirebaseFirestore db;

  FireStoreRepo._privateConstructor() : db = FirebaseFirestore.instance;

  static final FireStoreRepo _instance = FireStoreRepo._privateConstructor();

  factory FireStoreRepo() {
    return _instance;
  }

  Future<Fragrance> getFragranceById(String collectionPath,
      String documentId) async {
    DocumentSnapshot doc =
    await db.collection(collectionPath).doc(documentId).get();
    return Fragrance.fromFirestore(doc);
  }

  Future<List<Fragrance>> getFragrances() async {
    List<Fragrance> result = [];
    QuerySnapshot snapshot =
    await db.collection(Sdb.fragrances).orderBy(FieldPath.documentId).get();
    for (final e in snapshot.docs) {
      result.add(Fragrance.fromFirestore(e));
    }
    return result;
  }

  Stream<List<ForumPost>> getForumPosts(
      {DocumentSnapshot? startAfter, int limit = 10}) {
    Query query =
    db.collection(Sdb.posts).orderBy(FieldPath.documentId).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ForumPost.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Comment>> getCommentsByPostId(User? user, String postId) {
    return _fetchCommentsStream(postId, user, isRoot: true);
  }

  Stream<List<Comment>> _fetchCommentsStream(String id, User? user,
      {bool isRoot = false}) {
    DocumentReference reference = isRoot
        ? db.collection("posts").doc(id)
        : db.collection("comments").doc(id);

    return db
        .collection('comments')
        .where(isRoot ? 'post_id' : 'parent_comment', isEqualTo: reference)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Comment> comments = [];

      for (var doc in snapshot.docs) {
        var isLikedByMe =
            user != null && List<String>.from(doc['likes']).contains(user.uid);

        Comment comment = Comment(
          parent: isRoot ? null : doc['parent_comment'],
          id: doc.id,
          likeCount: doc['like_count'],
          replyCount: doc['reply_count'],
          author: doc['author_name'],
          content: doc['content'],
          timestamp: (doc['date'] as Timestamp).toDate(),
          likes: List<String>.from(doc['likes']),
          isLikedByMe: isLikedByMe,
          replies: [],
        );

        // Fetch nested replies using a Future
        comment.replies = await _fetchNestedReplies(comment.id, user);

        comments.add(comment);
      }

      return comments;
    });
  }

  Future<List<Comment>> _fetchNestedReplies(String parentId, User? user) async {
    DocumentReference reference = db.collection("comments").doc(parentId);

    QuerySnapshot replySnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('parent_id', isEqualTo: reference)
        .get();

    List<Comment> replies = [];

    for (var doc in replySnapshot.docs) {
      var isLikedByMe =
          user != null && List<String>.from(doc['likes']).contains(user.uid);

      Comment reply = Comment(
        parent: doc['parent_id'],
        id: doc.id,
        likeCount: doc['like_count'],
        replyCount: doc['reply_count'],
        author: doc['author_name'],
        content: doc['content'],
        timestamp: (doc['date'] as Timestamp).toDate(),
        likes: List<String>.from(doc['likes']),
        isLikedByMe: isLikedByMe,
        replies: [],
      );

      // Recursively fetch nested replies
      reply.replies = await _fetchNestedReplies(reply.id, user);

      replies.add(reply);
    }
    return replies;
  }

  void addComment(User user, String id, String content) async {
    Map<String, dynamic> docData = {};
    docData = {
      "author_name": user.displayName,
      "content": content,
      "date": DateTime.now(),
      "like_count": 0,
      "reply_count": 0,
      "post_id": db.collection(Sdb.posts).doc(id),
      "likes": List<String>.empty(growable: false),
      "replies": List<DocumentReference>.empty(growable: false)
    };
    db.collection("comments").add(docData);
  }

  void likeComment(User user, String commentId) {
    final docData = {
      "likes": FieldValue.arrayUnion([user.uid])
    };
    db
        .collection(Sdb.comments)
        .doc(commentId)
        .set(docData, SetOptions(merge: true));
  }

  void replyToComment(User user, String commentId, String content) async {
    DocumentReference parent = db.collection(Sdb.comments).doc(commentId);
    final docData = {
      "author_name": user.displayName,
      "content": content,
      "date": DateTime.now(),
      "like_count": 0,
      "likes": List<String>.empty(growable: false),
      "replies": List<DocumentReference>.empty(growable: false),
      "parent_comment": parent,
    };
    DocumentReference reply = await db.collection(Sdb.comments).add(docData);
    // update parent comment
    parent.set({
      "replies": FieldValue.arrayUnion([reply]),
      "reply_count": FieldValue.increment(1)
    }, SetOptions(merge: true));
  }

  void likePost(User user, String postId) {
    db.collection(Sdb.posts).doc(postId).set({
      "likes": FieldValue.arrayUnion([user.uid]),
      "like_count": FieldValue.increment(1)
    }, SetOptions(merge: true));
  }

  Future<List<Fragrance>> searchFragrances(String query) async {
    query = query.toLowerCase();
    List<String> searchTerms = query.split(' ');

    CollectionReference products =
    FirebaseFirestore.instance.collection('fragrances');

    // Perform initial queries
    List<QuerySnapshot> snapshots = await Future.wait([
      // Search for brand or name starting with any of the search terms
      ...searchTerms.map(
              (term) =>
              products.where('BrandLower', arrayContains: term[0]).get()),
      ...searchTerms.map(
              (term) =>
              products.where('NameLower', arrayContains: term[0]).get()),
    ]);

    // Use a map to ensure uniqueness based on document ID
    Map<String, DocumentSnapshot> uniqueResults = {};

    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        uniqueResults[doc.id] = doc;
      }
    }

    // Filter results manually
    List<DocumentSnapshot> filteredResults = uniqueResults.values.where((doc) {
      var brand = (doc['Brand'] as String).toLowerCase();
      var name = (doc['Name'] as String).toLowerCase();

      // Check if all search terms are contained in either brand or name
      bool allTermsMatch = searchTerms
          .every((term) => brand.contains(term) || name.contains(term));

      // Check if the full query is contained in either brand or name
      bool fullQueryMatch = brand.contains(query) || name.contains(query);

      return allTermsMatch || fullQueryMatch;
    }).toList();

    return filteredResults.map((e) => Fragrance.fromFirestore(e)).toList();
  }

  Future<void> incrementRating(String documentId,
      List<String> ratingKeys) async {
    final documentReference = FirebaseFirestore.instance
        .collection('ratings')
        .doc(documentId);

    DocumentSnapshot docSnapshot = await documentReference.get();

    if (!docSnapshot.exists) {
      await documentReference.set({
        'ratings': Ratings.GenerateGenericRatingsMap(),
      }, SetOptions(merge: true));
    }

    await documentReference.update({
      'ratings.SCENT.${ratingKeys[0]}': FieldValue.increment(1),
      'ratings.DURABILITY.${ratingKeys[1]}': FieldValue.increment(1),
      'ratings.SILLAGE.${ratingKeys[2]}': FieldValue.increment(1),
      'ratings.BOTTLE.${ratingKeys[3]}': FieldValue.increment(1),
    });
  }

  Future<Ratings> getFragranceRating(String fragranceId) async {
    DocumentSnapshot doc =
    await db.collection("ratings").doc(fragranceId).get();
    if (doc.exists) {
      return Ratings.FromFirestore(doc);
    } else {
      return Ratings(
          id: "",
          ratings: {});
    }
  }
}
