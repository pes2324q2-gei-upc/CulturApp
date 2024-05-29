import 'package:culturapp/domain/models/actividad.dart';

class Usuari {
  late String id; //-> token
  late String nom;
  late String email;
  late String image;
  late List<dynamic> devices;
  late List<String> activitats;
  late List<dynamic> favCategories;
  late List<Usuari> followers; //aka amigos
  late List<Actividad> valoradas;
}
