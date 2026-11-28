class Comment {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });
}