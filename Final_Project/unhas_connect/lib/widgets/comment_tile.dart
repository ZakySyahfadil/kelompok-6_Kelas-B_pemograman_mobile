import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../theme/app_colors.dart';
import '../utils/time_ago.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.isMine,
    required this.onDelete,
  });

  final Comment comment;
  final bool isMine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    const grey = Color(0xFF6B6B76);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFFCE4E8),
            child: Text(
              comment.authorName.isEmpty
                  ? '?'
                  : comment.authorName[0].toUpperCase(),
              style: const TextStyle(
                color: unhasMaroon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E6EA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                        Expanded(
                        child: Row(
                            children: [
                            Flexible(
                                child: Text(
                                comment.authorName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                ),
                                ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                                timeAgo(comment.createdAt),
                                style: const TextStyle(fontSize: 12, color: grey),
                            ),
                            ],
                        ),
                        ),
                        // Hanya komentar milik sendiri yang bisa dihapus
                        if (isMine)
                        InkWell(
                            onTap: onDelete,
                            child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.delete_outline, size: 18, color: grey),
                            ),
                        ),
                    ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: const TextStyle(fontSize: 15, height: 1.35),
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