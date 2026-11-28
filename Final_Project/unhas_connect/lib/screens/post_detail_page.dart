import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../repositories/comment_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/comment_tile.dart';
import '../widgets/post_card.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({
    super.key,
    required this.post,
    required this.repository,
    required this.currentUserId,
  });

  final Post post;
  final CommentRepository repository;
  final String currentUserId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  // Dibuat sekali di sini, jangan di dalam build()
  late final Stream<List<Comment>> _commentsStream =
      widget.repository.watchComments(widget.post.id);

  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      await widget.repository.addComment(widget.post.id, text);
      _controller.clear();
      // Gulir ke komentar terbaru (paling bawah)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Gagal mengirim komentar')),
          );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _confirmDelete(Comment comment) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus komentar?'),
        content: const Text('Komentar yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: unhasMaroon)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await widget.repository.deleteComment(widget.post.id, comment.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Postingan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _commentsStream,
              builder: (context, snapshot) {
                final comments = snapshot.data ?? const <Comment>[];
                final loading =
                    snapshot.connectionState == ConnectionState.waiting;

                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    PostCard(
                        post: widget.post,
                        commentCount: loading ? null : comments.length,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Komentar (${comments.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (snapshot.hasError)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('Gagal memuat komentar')),
                      )
                    else if (loading)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(color: unhasMaroon),
                        ),
                      )
                    else if (comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('Belum ada komentar. Jadilah yang pertama!'),
                        ),
                      )
                    else
                      for (final c in comments)
                        CommentTile(
                          comment: c,
                          isMine: c.authorId == widget.currentUserId,
                          onDelete: () => _confirmDelete(c),
                        ),
                  ],
                );
              },
            ),
          ),
          _CommentInputBar(
            controller: _controller,
            sending: _sending,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  const _CommentInputBar({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 280,
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar...',
                    filled: true,
                    fillColor: const Color(0xFFEFEFF2),
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (sending)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: unhasMaroon,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: onSend,
                  icon: const Icon(Icons.send_rounded, color: unhasMaroon),
                ),
            ],
          ),
        ),
      ),
    );
  }
}