import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class ForumPost {
  final String id;
  final VoidCallback? onTap;
  final String authorName;
  final String authorAvatarAsset;
  final DateTime postDate;
  final String title;
  final String content;
  final int likeCount;
  final int replyCount;
  final VoidCallback onLike;
  final VoidCallback onFollow;
  final VoidCallback onShare;
  final List<String> likes;

  ForumPost({
    this.onTap,
    required this.authorName,
    required this.authorAvatarAsset,
    required this.postDate,
    required this.title,
    required this.content,
    required this.likeCount,
    required this.replyCount,
    required this.onLike,
    required this.onFollow,
    required this.onShare,
    required this.likes,
    required this.id,
  });

  factory ForumPost.fromFirestore(
      DocumentSnapshot doc, {VoidCallback? onTap}
      ) {
    // Define placeholder callbacks if none are provided
    VoidCallback onLike = () {};
    VoidCallback onFollow = () {};
    VoidCallback onShare = () {};

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Safely handle likes list
    List<String> likes = (data['likes'] as List<dynamic>?)
        ?.map((item) => item.toString())
        .toList() ?? [];

    return ForumPost(
      onTap: onTap,
      authorName: data['author_name'] ?? '',
      authorAvatarAsset: 'assets/logos/male_sign.png',
      postDate: (data['date'] as Timestamp).toDate(),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      likeCount: data['like_count'] ?? 0,
      replyCount: data['reply_count'] ?? 0,
      likes: likes,
      onLike: onLike,
      onFollow: onFollow,
      onShare: onShare,
      id: doc.id,
    );
  }
}
