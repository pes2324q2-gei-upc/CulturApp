class Post {
  late final String username;
  late final String message;
  late final DateTime date;
  late int likes;

  Post({
    required this.username,
    required this.message,
    required this.date,
    this.likes = 0,
  });
}