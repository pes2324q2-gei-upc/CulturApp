class Post {
  //late int foroId; //esto maybe hacer que el foro tenga un listado de id y que luego los busque
  late int id;
  late final String userId; 
  late final String message;
  late final DateTime date;
  late int likes;

  Post({
    required this.userId,
    required this.message,
    required this.date,
    this.likes = 0,
  });

  //pasar a map
  //es necesario pasar-lo a json?
  Post.fromJson(Map<String, dynamic> json){
    id: json["id"];
    userId: json["userId"];
    message: json["message"];
    date: DateTime.parse(json["date"]);
    likes: json["likes"];
  }

    Map<String, dynamic> toMap(){
      return {
        'id': id,
        'userId': userId,
        'message': message,
        'date': date, 
        'likes': likes,
      };
  }
}