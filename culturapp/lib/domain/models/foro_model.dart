import 'package:culturapp/domain/models/post.dart';

class Foro {
  late final String activitat_code;
  late List<Post>? posts; //listado de ids de posts


  Foro({
    required this.activitat_code,
    this.posts = const [], 
  });

  // Factory method para convertir JSON a objeto Foro
  factory Foro.fromJson(Map<String, dynamic> json) {
    return Foro(
      activitat_code: json['activitat_code'],
      posts: json['posts'] != null ? List<Post>.from(json['posts'].map((post) => Post.fromJson(post))) : null,
    );
  }
}