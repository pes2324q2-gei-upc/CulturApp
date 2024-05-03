import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserLogged{
  late String tokenUserLogged;
  late String usernameUserLogged;

  void setToken(String token){
    tokenUserLogged = token;
  }

  String getToken(){
    return tokenUserLogged;
  }

  void setUsername(String username){
    usernameUserLogged = username;
  }

  String getUsername(){
    return usernameUserLogged;
  }
}

class ControladorDomini {
  final String ip = "10.0.2.2";
  final UserLogged userLogged = UserLogged();


  Future<void> setInfoUserLogged(String uid) async {
    final respuesta = await http.get(Uri.parse('https://culturapp-back.onrender.com/users/infoToken'),
    headers: {'Authorization' : 'Bearer $uid'});

    if (respuesta.statusCode == 200) {
      var data = json.decode(respuesta.body);
        userLogged.setToken(data['token']);
        print(userLogged.getToken());
        userLogged.setUsername(data['username']);
      
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<bool> accountExists(User? user) async {
    print(user?.uid);
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/exists?uid=${user?.uid}'));
       
      print(respuesta.statusCode);
      print(respuesta.body);
    if (respuesta.statusCode == 200) {
      return (respuesta.body == "exists");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<bool> createUser(User? user, String username, List<String> selectedCategories) async {
    try {

      final Map<String, dynamic> userdata = {
        'uid': user?.uid,
        'username': username,
        'email': user?.email,
        'favcategories': selectedCategories
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/create'),
        body: jsonEncode(userdata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
        setInfoUserLogged(user!.uid);
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }

    return true;
  }

  void editUser(User? user, String username, List<String> selectedCategories) async {
    try {
      final Map<String, dynamic> userdata = {
        'uid': user?.uid,
        'username': username,
        'favcategories': jsonEncode(selectedCategories),
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/edit'), 
        body: jsonEncode(userdata),
        headers: {'Authorization': 'Bearer ${userLogged.getToken()}',
                  'Content-Type': 'application/json'},
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
        'https://culturapp-back.onrender.com/users/uniqueUsername?username=$username'));

    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "unique");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> obteCatsFavs(String username) async {
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/${username}/favcategories')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );
    List<String> categorias = [];

    if (respuesta.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(respuesta.body);
      categorias = jsonResponse.cast<String>();
    }
    return categorias;
  }

  Future<List<Actividad>> getActivitiesAgenda() async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/read/all')
          , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
          }
        );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

    Future<List<Usuario>> getUsers() async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/users/read/users')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list_user(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> getUserActivities() async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/${userLogged.getUsername()}/activitats'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchMyActivities(String name) async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/activitats/search/$name'), //FALTA AÑADIR TOKENS
    headers: {
      'Authorization': 'Bearer ${userLogged.getToken()}',
    });

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No existe la actividad $name');
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchActivitat(String squery) async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/name/$squery')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );

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

  Future<bool> isUserInActivity(String? uid, String code) async {
    final respuesta = await http.get(Uri.parse(
        'https://culturapp-back.onrender.com/users/activitats/isuserin?id=$uid&activityId=$code'),
        headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        } 
        );

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
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${userLogged.getToken()}',
                },
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

  Future<List<dynamic>> obteFollows(String username, String endpoint) async {
      final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/amics/$username/$endpoint'),
      headers: {
      'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );
    if (respuesta.statusCode == 200) {
      final body = respuesta.body;
      final List<dynamic> data = json.decode(body);
      return data;
    } 
    else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> getRequestsUser() async {

    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/amics/followingRequests'), 
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );
    if(respuesta.statusCode == 200) {
      final body = respuesta.body;
      final List<dynamic> data = json.decode(body);
      final List<String> users = data.map((user) => user['friend'].toString()).toList(); 
      return users;
    }
    else {
      throw Exception('Fallo la obtención de datos' /*"data_error_msg".tr(context)*/);
    }
  }

  Future<void> acceptFriend(String person) async {
    final http.Response response = await http.put(
      Uri.parse('https://culturapp-back.onrender.com/amics/accept/$person'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al aceptar al usuario');
  }

  Future<void> deleteFriend(String person) async {
    final http.Response response = await http.delete(
      Uri.parse('https://culturapp-back.onrender.com/amics/delete/$person'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
  }

  Future<void> createFriend(String person) async {
    final Map<String, dynamic> body = {
        'friend': person,
      };

    final http.Response response = await http.post(
      Uri.parse('https://culturapp-back.onrender.com/amics/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
      body: jsonEncode(body),
    );

    print(response.body);

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
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
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${userLogged.getToken()}',},
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

  Future<int> sendReportBug(String titulo, String reporte) async {

      final Map<String, dynamic> body = {
        'titol': titulo,
        'report': reporte,
      };

      try {
        final response = await http.post(
          Uri.parse('https://culturapp-back.onrender.com/tickets/reportBug/create'),
          headers: {
            'Content-Type': 'application/json', 
            'Authorization': 'Bearer ${userLogged.getToken()}',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          print('Reporte enviado exitosamente');
        } else {
          print('Error al enviar el reporte: ${response.body}');
        }
        return response.statusCode;
      } catch (e) {
        print(e);
        return 500;
      }
  }

  Future<int> sendOrganizerApplication(String titol, String idActivitat, String motiu) async {

      final Map<String, dynamic> body = {
        'titol': titol,
        'idActivitat': idActivitat,
        'motiu': motiu,
      };

      try {
        final response = await http.post(
          Uri.parse('https://culturapp-back.onrender.com/tickets/solicitudsOrganitzador/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${userLogged.getToken()}',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          print('Solicitud enviada exitosamente');
          return 200;
        } else {
          print('Error al enviar la solicitud: ${response.body}');
          return 500;
        }
      } catch (e) {
        print(e);
        return 500;
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

  List<Usuario> _convert_database_to_list_user(response) {
    List<Usuario> usuarios = <Usuario>[];
    var usr = json.decode(response.body);

    if (usr is List) {
      usr.forEach((userJson) {
        Usuario usuario = Usuario();

        usuario.username = userJson['username'];
        usuario.favCats = userJson['favcategories'] ?? '';
        usuario.identificador = userJson['id'];
        
        usuarios.add(usuario);
      });
    }

    return usuarios;
  }

  List<Actividad> _convert_json_to_list(response) {
    var actividades = <Actividad>[];

    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        actividades.add(actividad);
      }
    }

    return actividades;
  }

}

