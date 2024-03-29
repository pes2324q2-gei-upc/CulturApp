import 'package:culturapp/domain/models/post.dart';

class Foro {
  late String uid;
  late int num_comentaris;
  late final String activitat_code;
  late List<Post> posts; //listado de ids de posts


  Foro({
    int numComentaris = 0,
    required this.activitat_code,
    required num_comentaris,
    List<Post> posts = const [], 
  });
}