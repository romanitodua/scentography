import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final int? likeCount;
  final String author;
  final String content;
  final DateTime timestamp;
  final List<String>? likes;
  bool isLikedByMe;
  List<Comment>? replies;

  Comment({
    required this.likeCount,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.isLikedByMe,
    this.replies,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc, User? user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isLikedByMe = false;
    if (user != null) {
      isLikedByMe = (data['likes'] as List<dynamic>?)
          ?.contains(user.uid) ?? false;
    }

    // Parse the replies
    List<Comment>? replies;
    if (data['replies'] != null) {
      replies = (data['replies'] as List<dynamic>)
          .map((replyDoc) => Comment.fromFirestore(replyDoc, user))
          .toList();
    }

    return Comment(
      likeCount: data['like_count'] ?? 0,
      author: data['author_name'],
      content: data['content'],
      timestamp: (data['date'] as Timestamp).toDate(),
      likes: (data['likes'] as List<dynamic>?)?.cast<String>() ?? [],
      isLikedByMe: isLikedByMe,
      replies: replies,
    );
  }
}
