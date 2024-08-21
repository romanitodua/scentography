import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:scentography/data/providers.dart';
import 'package:scentography/data/repositories/firestore.dart';
import 'package:scentography/features/forum/providers/auth_provider.dart';

import '../../../domain/comment.dart';
import '../../../domain/forum_post.dart';

class FullPostView extends ConsumerStatefulWidget {
  final ForumPost post;

  FullPostView({super.key, required this.post});

  @override
  _FullPostViewState createState() => _FullPostViewState();
}

class _FullPostViewState extends ConsumerState<FullPostView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fireStoreRepoProvider);
    final user = ref.watch(authUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Post")),
      body: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/logos/male_sign.png'),
                  ),
                  title: Text(widget.post.authorName),
                  subtitle: Text(widget.post.postDate.toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(widget.post.content),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, size: 20),
                      Text(widget.post.likeCount.toString()),
                      Spacer(),
                      Text('${widget.post.replyCount} replies'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(child: CommentsSection(postId: widget.post.id)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Enter your comment',
                      border: InputBorder.none,
                      // Remove the default underline border
                      labelStyle: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide.none, // Removes the outline
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  onPressed: () {
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Sign in to comment")));
                    } else {
                      repo.addComment(
                          user, widget.post.id, _commentController.text);
                      _commentController.clear();
                    }
                  },
                  child: Icon(Icons.upload, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }
}

class CommentsSection extends ConsumerStatefulWidget {
  final String postId;

  CommentsSection({required this.postId});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends ConsumerState<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fireStoreRepoProvider);
    final user = ref.watch(authUserProvider);
    return StreamBuilder<List<Comment>>(
      stream: repo.getCommentsByPostId(user, widget.postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No comments yet.');
        }

        return ListView(
          children: snapshot.data!
              .map((comment) =>
              CommentWidget(
                comment: comment,
                onLike: () {
                  if (user==null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sign in to comment")));
                  }
                  else {
                    repo.likeComment(user,comment.id);
                    setState(() {
                    });
                  }
                },
              ))
              .toList(),
        );
      },
    );
  }
}

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Function onLike;

  CommentWidget({required this.comment, required this.onLike});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.author,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.comment.content,
                    softWrap: true,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => widget.onLike,
                          icon: Icon(
                            Iconsax.heart4,
                            color: widget.comment.isLikedByMe
                                ? Colors.red
                                : Colors.black,
                          )),
                      Text(
                        widget.comment.likeCount.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
