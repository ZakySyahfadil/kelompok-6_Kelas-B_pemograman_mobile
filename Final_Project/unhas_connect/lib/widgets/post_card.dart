import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../utils/time_ago.dart';

class PostCard extends StatefulWidget {
 const PostCard({
    super.key,
    required this.post,
    this.onCommentTap,
    this.commentCount,
  });

  final Post post;
  final VoidCallback? onCommentTap;
  final int? commentCount;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _liked = false;
  bool _saved = false;

  late int _likeCount;

  @override
  void initState() {
    super.initState();

    // Mengambil jumlah like awal dari data postingan
    _likeCount = widget.post.likeCount;
  }

  // Fungsi like dan unlike
  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    const grey = Color(0xFF6B6B76);

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6EA)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER POSTINGAN
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFCE4E8),

                child: Text(
                  post.authorName.isNotEmpty
                      ? post.authorName[0].toUpperCase()
                      : '?',

                  style: const TextStyle(
                    color: unhasMaroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      post.authorName,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '${post.faculty} • ${post.major}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(fontSize: 13, color: grey),
                    ),

                    Row(
                      children: [
                        Text(
                          timeAgo(post.createdAt),

                          style: const TextStyle(fontSize: 13, color: grey),
                        ),

                        const SizedBox(width: 6),

                        const Icon(Icons.public, size: 14, color: grey),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // LABEL KATEGORI
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4E8),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  post.category,

                  style: const TextStyle(
                    color: unhasMaroon,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              IconButton(
                onPressed: () {
                  // TODO: Hapus / laporkan postingan
                },

                icon: const Icon(Icons.more_vert),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          // ISI POSTINGAN
          const SizedBox(height: 12),

          Text(post.content, style: const TextStyle(fontSize: 16, height: 1.4)),

          // GAMBAR POSTINGAN (OPSIONAL)
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,

                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return Container(
                    height: 190,
                    color: const Color(0xFFEFEFF2),
                    alignment: Alignment.center,

                    child: const CircularProgressIndicator(color: unhasMaroon),
                  );
                },

                errorBuilder: (context, error, stack) {
                  return Container(
                    height: 190,
                    color: const Color(0xFFEFEFF2),
                    alignment: Alignment.center,

                    child: const Icon(Icons.broken_image_outlined, color: grey),
                  );
                },
              ),
            ),
          ],

          // TOMBOL INTERAKSI
          const Divider(height: 24),

          Row(
            children: [
              // LIKE
              _ActionButton(
                icon: _liked ? Icons.favorite : Icons.favorite_border,

                color: _liked ? unhasMaroon : grey,

                label: '$_likeCount',

                onTap: _toggleLike,
              ),

              const SizedBox(width: 20),

              // KOMENTAR
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                color: grey,
                label: '${widget.commentCount ?? post.commentCount}',
                onTap: widget.onCommentTap ?? () {},
              ),

              const Spacer(),

              // BOOKMARK
              IconButton(
                onPressed: () {
                  setState(() {
                    _saved = !_saved;
                  });
                },

                icon: Icon(
                  _saved ? Icons.bookmark : Icons.bookmark_border,

                  color: _saved ? unhasMaroon : grey,
                ),

                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// WIDGET TOMBOL INTERAKSI
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),

        child: Row(
          children: [
            Icon(icon, color: color, size: 24),

            const SizedBox(width: 6),

            Text(
              label,

              style: const TextStyle(fontSize: 15, color: Color(0xFF3A3A44)),
            ),
          ],
        ),
      ),
    );
  }
}
