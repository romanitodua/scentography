import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/data/providers.dart';
import 'package:scentography/features/forum/providers/auth_provider.dart';

import '../../../data/repositories/firestore.dart';
import '../models/comment.dart';
import '../models/forum_post.dart';
import 'comment_card_widget.dart';

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
          StreamBuilder(
            stream: repo.getCommentsByPostId(user, widget.post.id),
            builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container();
              }

              return Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var comment = snapshot.data![index];
                  return CommentCard(comment: comment);
                },
              ));
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You must be logged in to comment.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    _postComment(repo, user, widget.post.id, context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _postComment(FireStoreRepo repo, User user, String postId,
      BuildContext context) async {
    if (_commentController.text.isNotEmpty) {
      bool delivered =
          await repo.addComment(user, postId, _commentController.text);
      if (delivered) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('sent'),
              duration: Duration(seconds: 1),
            ),
          );
          FocusScope.of(context).unfocus();
        }

      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('not delivered'),
            duration: Duration(seconds: 2),
          ),
        );
        FocusScope.of(context).unfocus();
      }
    }
    _commentController.clear();
  }
}
