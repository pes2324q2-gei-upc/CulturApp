import 'package:culturapp/domain/models/user.dart';

int calculaCoincidencias(List<String>categFav, List<String>categsUserActual){
  int coincidencias = 0;
  
  for (int i = 0; i < 3; ++i){
    bool cont = true;
    for(int j = 0; j < 3 && cont; ++j){
      if (categsUserActual[i] == categFav[j]){
        ++coincidencias;
        cont = false;
      }
    }
  }
  return coincidencias;
}

List<Usuario> calculaUsuariosRecomendados(List<Usuario>users, String idActual, List<String>categoriasFavoritas){
  List<Usuario>recomms = [];

  for (int i = 0; i < users.length || recomms.length == 3; ++i){
    if (users[i].identificador != idActual){
      List<String> favcats = [];
      favcats = users[i].favCats.cast<String>();
      if (calculaCoincidencias(favcats, categoriasFavoritas) > 0) {
        recomms.add(users[i]);
      }
    }
  }

  if (recomms.isEmpty){
    for (int i = 0; i < users.length && recomms.length < 3; ++i){
      if (users[i].identificador != idActual){
        recomms.add(users[i]);
      }
    }
  }
  return recomms;
}

