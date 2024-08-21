// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../domain/comment.dart';
//
// class CommentCard extends ConsumerStatefulWidget {
//   final Comment comment;
//
//   const CommentCard({super.key, required this.comment});
//
//   @override
//   ConsumerState<CommentCard> createState() => _CommentCardState();
// }
//
// class _CommentCardState extends ConsumerState<CommentCard> {
//   bool showReplies = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final comment = widget.comment;
//     final hasReplies = comment.replies.isNotEmpty;
//
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   comment.author,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Spacer(),
//                 Text(comment.timestamp.toString()),
//               ],
//             ),
//             SizedBox(height: 4),
//             Text(comment.content),
//             SizedBox(height: 4),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.favorite,
//                       size: 16,
//                       color: comment.isLikedByMe ? Colors.red : Colors.grey,
//                     ),
//                     SizedBox(width: 4),
//                     Text(comment.likeCount.toString()),
//                   ],
//                 ),
//                 Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     if (hasReplies) {
//                       setState(() {
//                         showReplies = !showReplies;
//                       });
//                     }
//                     ref.read(selectedCommentProvider.notifier).state =
//                         comment;
//                   },
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Text(
//                       "${comment.replyCount} replies",
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (showReplies && hasReplies)
//               Padding(
//                 padding: EdgeInsets.only(left: 16.0, top: 8.0),
//                 child: Column(
//                   children: comment.replies.map((reply) {
//                     return CommentCard(comment: reply);
//                   }).toList(),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
