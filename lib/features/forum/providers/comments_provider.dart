import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scentography/data/providers.dart';

import '../../../domain/comment.dart';

part 'comments_provider.g.dart';

@riverpod
Stream<List<Comment>> commentsProvider(CommentsProviderRef ref, {User? user, required String postId}) {
  final repo = ref.watch(fireStoreRepoProvider);
  return repo.getCommentsByPostId(user, postId);
}
