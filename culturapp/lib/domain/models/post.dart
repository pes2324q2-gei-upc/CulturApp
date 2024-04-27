class Post {
  late String username; 
  late String mensaje;
  late String fecha; //cambiar por un timeStamp
  late int numeroLikes;

  Post({
    required this.username,
    required this.mensaje,
    required this.fecha,
    this.numeroLikes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'], 
      mensaje: json['mensaje'], 
      fecha: json['fecha'], 
      numeroLikes: json['numero_likes'], 
    );
  }
}