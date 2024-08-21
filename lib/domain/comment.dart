import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final DocumentReference? parent;
  final String id;
  final int likeCount;
  final int replyCount;
  final String author;
  final String content;
  final DateTime timestamp;
  final List<String> likes;
  bool isLikedByMe;
  List<Comment> replies;

  Comment({
    required this.parent,
    required this.replyCount,
    required this.id,
    required this.likeCount,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.isLikedByMe,
    required this.replies,
  });
}
