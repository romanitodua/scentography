import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:scentography/features/forum/providers/auth_provider.dart';
import 'package:scentography/features/forum/screens/post_card_widget.dart';
import 'package:scentography/features/forum/screens/post_view_widget.dart';

import '../../../data/providers.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fireStoreRepoProvider);
    User? user = ref.watch(authUserProvider);
    bool isLoggedIn = user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
        actions: [
          GestureDetector(
            child: isLoggedIn
                ? const Icon(Iconsax.logout)
                : const Icon(Iconsax.login),
            onTap: () {
              if (isLoggedIn) {
                ref.read(authUserProvider.notifier).signOut();
              } else {
                ref.read(authUserProvider.notifier).signIn();
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errorsdsdsds: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts'));
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var post = snapshot.data![index];
                return ForumPostCard(
                  post: post,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FullPostView(
                            post: post,
                          );
                        },
                      ),
                    );
                  },
                );
              });
        },
        future: repo.getForumPosts("posts"),
      ),
    );
  }
}
