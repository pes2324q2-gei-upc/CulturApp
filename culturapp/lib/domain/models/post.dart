class Post {
  late String username; 
  late String mensaje;
  late String fecha; 
  late int numeroLikes;
  late bool esOrganitzador;

  Post({
    required this.username,
    required this.mensaje,
    required this.fecha,
    this.numeroLikes = 0,
    required this.esOrganitzador
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'], 
      mensaje: json['mensaje'], 
      fecha: json['fecha'], 
      numeroLikes: json['numero_likes'], 
      esOrganitzador: json['esOrganitzador']
    );
  }
}