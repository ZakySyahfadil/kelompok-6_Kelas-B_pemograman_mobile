class Post {
  final String id;
  final String authorName;
  final String faculty;
  final String major;
  final String content;
  final String category;
  final String? imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;

  const Post({
    required this.id,
    required this.authorName,
    required this.faculty,
    required this.major,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
  });
}