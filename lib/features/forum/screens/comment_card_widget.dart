import 'package:flutter/material.dart';

import '../models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(comment.author,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text(comment.timestamp.toString()),
              ],
            ),
            SizedBox(height: 4),
            Text(comment.content),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: comment.isLikedByMe ? Colors.red : Colors.white,
                ),
                SizedBox(width: 4),
                Text(comment.likeCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}