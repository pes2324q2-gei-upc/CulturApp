import 'package:culturapp/domain/models/user.dart';




List<Usuario> calculaUsuariosRecomendados(List<Usuario>users, String idActual, List<String>categoriasFavoritas){
  List<Usuario>recomms = [];

  for (int i = 0; i < users.length; ++i){
    if (users[i].identificador != idActual){
      List<String> favcats = [];
      favcats = users[i].favCats.cast<String>();
    //Funcion para calcular cuales son los usuarios similares
    }
  }

  return recomms;
}

