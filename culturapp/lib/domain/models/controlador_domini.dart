import 'dart:convert';

import 'package:culturapp/domain/models/actividad.dart';
import 'package:http/http.dart' as http;


class ControladorDomini {
  
  Future <List<Actividad>> getActivitiesAgenda() async {

    final respuesta = await http.get(Uri.parse('http://10.0.2.2:8080/read/all'));
    
    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    }
    else {
      throw Exception('Fallo la obtención de datos');
    }

  }

  Future<List<Actividad>> getUserActivities(String userID) async {
    final respuesta = await http.get(
      Uri.parse('http://10.0.2.2:8080/activitats/user/$userID'),
    );

    if (respuesta.statusCode == 200) {
      return _convert_json_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  List<Actividad> _convert_database_to_list(response) {
    
    List<Actividad> actividades = <Actividad>[];
    var actividadesJson = json.decode(response.body);
    
    for (var actividadJson in actividadesJson) {
      Actividad actividad = Actividad();
      
      actividad.name = actividadJson['denominaci'];
      actividad.code = actividadJson['codi'];
      actividad.latitud = actividadJson['latitud'].toDouble();
      actividad.longitud = actividadJson['longitud'].toDouble();
      actividad.descripcio = actividadJson['descripcio'] ?? 'No hi ha cap descripció per aquesta activitat.';
      actividad.ubicacio = actividadJson['adre_a'] ?? 'No disponible';
      actividad.visualitzacions = actividadJson['visualitzacions'] ?? 0;
      actividad.categoria = actividadJson['tags_categor_es'] ?? '';
      
      String imagenes = actividadJson['imatges'] ?? '';
      if (imagenes != '') {
        int endIndex = imagenes.indexOf(',');
        if (endIndex != -1) {
            actividad.imageUrl = "https://agenda.cultura.gencat.cat" + imagenes.substring(0, endIndex);
        } else {
          actividad.imageUrl = "https://agenda.cultura.gencat.cat" + imagenes;
        }
    }
      
      String data = actividadJson['data_inici'] ?? '';
      actividad.dataInici = data.isNotEmpty ? data.substring(0, 10) : '-';
      if (actividad.dataInici == '9999-09-09') actividad.dataInici = 'Sense Data';
      
      data = actividadJson['data_fi'] ?? '';
      actividad.dataFi = data.isNotEmpty ? data.substring(0, 10) : '-';
      if (actividad.dataFi == '9999-09-09') actividad.dataFi = 'Sense Data';
      
      String url = actividadJson['enlla_os'] ?? '';
      if (url.isNotEmpty) {
        int endIndex = url.indexOf(',');
        actividad.urlEntrades = Uri.parse(endIndex != -1 ? url.substring(0, endIndex) : url);
      }
      
      String entrades = actividadJson['entrades'] ?? 'Veure més informació';
      if (entrades.isNotEmpty) {
        int endIndex = entrades.indexOf('€');
        actividad.preu = endIndex != -1 ? entrades.substring(0, endIndex) : entrades;
      }
      
      actividades.add(actividad);
    }
    
    return actividades;
  }

  List<Actividad> _convert_json_to_list(response) {

    var actividades = <Actividad>[];

    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
          actividades.add(actividad);
          print(actividad.visualitzacions);
        }
      }
    
    return actividades;
  }

}