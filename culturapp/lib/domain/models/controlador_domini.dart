import 'dart:convert';


import 'package:culturapp/domain/models/actividad.dart';
import 'package:http/http.dart' as http;


class ControladorDomini {
  
  Future <List<Actividad>> getActivities() async {

    final respuesta = await http.get(Uri.parse('https://10.0.2.2:8080/read/all'));
    
    if (respuesta.statusCode == 200) {
      return _convert_json_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }

  }

  List<Actividad> _convert_json_to_list(response){
    
    List<Actividad> actividades = <Actividad>[];
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        actividades.add(actividad);
      }
    return actividades;
    
  }

}