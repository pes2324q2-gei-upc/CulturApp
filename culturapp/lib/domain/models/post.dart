import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  late String id;
  late String username; 
  late String mensaje;
  late String fecha; //cambiar por un timeStamp
  late int numero_likes;

  Post({
    required this.id,
    required this.username,
    required this.mensaje,
    required this.fecha,
    this.numero_likes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'], 
      username: json['username'], 
      mensaje: json['mensaje'], 
      fecha: json['fecha'], 
      numero_likes: json['numero_likes'], 
    );
  }
}