class Post {
  late String id;
  late String username; 
  late String mensaje;
  late DateTime fecha; //cambiar por un timeStamp
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
      id: json['id'], // Cambiado para coincidir con el nombre del campo devuelto por la API
      username: json['username'], // Cambiado para coincidir con el nombre del campo devuelto por la API
      mensaje: json['mensaje'], // Cambiado para coincidir con el nombre del campo devuelto por la API
      fecha: DateTime.fromMillisecondsSinceEpoch(json['fecha']['_seconds'] * 1000 + (json['fecha']['_nanoseconds'] / 1000000).round()), // Modificado para manejar el campo de fecha devuelto por la API
      numero_likes: json['numero_likes'], // Cambiado para coincidir con el nombre del campo devuelto por la API
    );
  }
}