import 'dart:async';
import '../data/dummy_comments.dart';
import '../models/comment.dart';

abstract class CommentRepository {
  Stream<List<Comment>> watchComments(String postId);
  Future<void> addComment(String postId, String content);
  Future<void> deleteComment(String postId, String commentId);
}

/// Dummy: data disimpan di memori. Hilang saat aplikasi di-restart.
class DummyCommentRepository implements CommentRepository {
  DummyCommentRepository._();

  // Satu instance dipakai bersama, supaya komentar yang kamu tulis
  // tidak hilang saat halaman detail ditutup lalu dibuka lagi.
  static final DummyCommentRepository instance = DummyCommentRepository._();

  final Map<String, List<Comment>> _store = buildDummyComments();
  final StreamController<String> _changes = StreamController<String>.broadcast();
  int _nextId = 1000;

  List<Comment> _snapshot(String postId) {
    final list = [...(_store[postId] ?? <Comment>[])];
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // lama -> baru
    return list;
  }

  @override
  Stream<List<Comment>> watchComments(String postId) async* {
    yield _snapshot(postId);
    yield* _changes.stream.where((id) => id == postId).map(_snapshot);
  }

  @override
  Future<void> addComment(String postId, String content) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulasi jaringan
    _store.putIfAbsent(postId, () => []).add(
          Comment(
            id: 'c${_nextId++}',
            authorId: dummyCurrentUserId,
            authorName: dummyCurrentUserName,
            content: content,
            createdAt: DateTime.now(),
          ),
        );
    _changes.add(postId);
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    _store[postId]?.removeWhere((c) => c.id == commentId);
    _changes.add(postId);
  }
}