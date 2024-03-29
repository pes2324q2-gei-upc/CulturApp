import 'package:culturapp/domain/models/post.dart';

class Foro {
  late String uid;
  late int num_comentaris;
  late final String activitat_code;
  late List<Post> posts; //listado de ids de posts


  Foro({
    required this.activitat_code,
    required this.num_comentaris,
    this.uid = '', // inicializamos uid con un valor predeterminado
    this.posts = const [], // inicializamos posts con una lista vacía por defecto
  });
}