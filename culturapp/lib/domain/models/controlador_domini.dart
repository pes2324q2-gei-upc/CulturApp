import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ControladorDomini {
  final String ip = "10.0.2.2";

  Future<List<Actividad>> getActivitiesAgenda() async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/read/all'));

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> getUserActivities(String userID) async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/$userID/activitats'),
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchMyActivities(String userID, String name) async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/activitats/$userID/search/$name'),
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No existe la actividad ' + name);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchActivitat(String squery) async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/name/$squery'));

    if (respuesta.statusCode == 200) {
      //final List<dynamic> responseData = jsonDecode(respuesta.body);
      //return Actividad.fromJson(responseData.first);
      return _convert_database_to_list(respuesta);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No existe la actividad ' + squery);
    } else {
      throw Exception('Fallo en buscar la actividad');
    }
  }

  List<Actividad> _convert_database_to_list(response) {
    List<Actividad> actividades = <Actividad>[];
    var actividadesJson = json.decode(response.body);

    if (actividadesJson is List) {
      actividadesJson.forEach((actividadJson) {
        Actividad actividad = Actividad();

        actividad.name = actividadJson['denominaci'];
        actividad.code = actividadJson['codi'];
        actividad.latitud = actividadJson['latitud'].toDouble();
        actividad.longitud = actividadJson['longitud'].toDouble();
        actividad.descripcio = actividadJson['descripcio'] ??
            'No hi ha cap descripció per aquesta activitat.';
        actividad.ubicacio = actividadJson['adre_a'] ?? 'No disponible';
        actividad.visualitzacions = actividadJson['visualitzacions'] ?? 0;
        actividad.categoria = actividadJson['tags_categor_es'] ?? '';

        actividad.imageUrl = actividadJson['imatges'] ?? '';

        String data = actividadJson['data_inici'] ?? '';
        actividad.dataInici = data.isNotEmpty ? data.substring(0, 10) : '-';
        if (actividad.dataInici == '9999-09-09')
          actividad.dataInici = 'Sense Data';

        data = actividadJson['data_fi'] ?? '';
        actividad.dataFi = data.isNotEmpty ? data.substring(0, 10) : '-';
        if (actividad.dataFi == '9999-09-09') actividad.dataFi = 'Sense Data';

        String url = actividadJson['enlla_os'] ?? '';
        if (url.isNotEmpty) {
          int endIndex = url.indexOf(',');
          actividad.urlEntrades =
              Uri.parse(endIndex != -1 ? url.substring(0, endIndex) : url);
        }

        String entrades = actividadJson['entrades'] ?? 'Veure més informació';
        if (entrades.isNotEmpty) {
          int endIndex = entrades.indexOf('€');
          actividad.preu =
              endIndex != -1 ? entrades.substring(0, endIndex) : entrades;
        }

        actividades.add(actividad);
      });
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

  Future<bool> accountExists(User? user) async {
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/exists?uid=${user?.uid}'));

    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "exists");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> obteCatsFavs(User? user) async {
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/${user?.uid}/favcategories'));
    List<String> categorias = [];

    if (respuesta.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(respuesta.body);
      categorias = jsonResponse.cast<String>();
    }
    return categorias;
  }

  void createUser(
      User? _user, String username, List<String> selectedCategories) async {
    try {
      final Map<String, dynamic> userdata = {
        'uid': _user?.uid,
        'username': username,
        'email': _user?.email,
        'favcategories': jsonEncode(selectedCategories),
        'activities': [],
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/create'),
        body: jsonEncode(userdata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  void signoutFromActivity(String? uid, String code) async {
    try {
      final Map<String, dynamic> requestData = {
        'uid': uid,
        'activityId': code,
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/activitats/signout'),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }

  }

  Future<bool> isUserInActivity(String? uid, String code) async {
    final respuesta = await http.get(Uri.parse(
        'https://culturapp-back.onrender.com/users/activitats/isuserin?uid=${uid}&activityId=${code}'));

    if (respuesta.statusCode == 200) {
      return (respuesta.body == "yes");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  void signupInActivity(String? uid, String code) async {
    try {
      final Map<String, dynamic> requestData = {
        'uid': uid,
        'activityId': code,
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/activitats/signup'),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  Future<bool> usernameUnique(String username) async {
    final respuesta = await http.get(Uri.parse(
        'https://culturapp-back.onrender.com/users/uniqueUsername?username=${username}'));

    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "unique");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }
}
