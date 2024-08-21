import 'package:flutter/material.dart';
import 'package:scentography/domain/forum_post.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback onTap;

  const ForumPostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(post.authorAvatarAsset),
              ),
              title: Text(post.authorName),
              subtitle: Text(post.postDate.toString()),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(post.content),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.favorite, size: 20),
                  Text(
                    post.likeCount.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Spacer(),
                  Text("${post.replyCount} replies"),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: post.onLike,
                    icon: Icon(Icons.thumb_up),
                    label: Text('Like'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: post.onFollow,
                    icon: Icon(Icons.notifications),
                    label: Text('Follow'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: post.onShare,
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
