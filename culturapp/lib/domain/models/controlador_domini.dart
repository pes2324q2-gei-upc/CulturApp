import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/grup.dart';
import 'package:culturapp/domain/models/message.dart';
import 'package:culturapp/domain/models/xat_amic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ControladorDomini {
  //ip default: 10.0.2.2
  final String ip = "10.0.2.2";

  Future<List<Actividad>> getActivitiesAgenda() async {
    final respuesta =
        await http.get(Uri.parse('http://${ip}:8080/activitats/read/all'));

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> getUserActivities(String userID) async {
    final respuesta = await http.get(
      Uri.parse('http://${ip}:8080/users/$userID/activitats'),
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchMyActivities(String userID, String name) async {
    final respuesta = await http.get(
      Uri.parse('https://${ip}:8080/users/activitats/$userID/search/$name'),
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
        await http.get(Uri.parse('https://${ip}:8080/activitats/name/$squery'));

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
        .get(Uri.parse('https://${ip}:8080/users/exists?uid=${user?.uid}'));

    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "exists");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> obteCatsFavs(User? user) async {
    final respuesta = await http
        .get(Uri.parse('http://${ip}:8080/users/${user?.uid}/favcategories'));
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
        Uri.parse(
            'https://culturapp-back.onrender.com/users/activitats/signout'),
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
        Uri.parse(
            'https://culturapp-back.onrender.com/users/activitats/signup'),
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

  Future<String> getUsername(String uid) async {
    final respuesta = await http
        .get(Uri.parse('http://${ip}:8080/users/username?uid=${uid}'));

    if (respuesta.statusCode == 200) {
      return respuesta.body;
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  void editUser(
      User? _user, String username, List<String> selectedCategories) async {
    try {
      final Map<String, dynamic> userdata = {
        'uid': _user?.uid,
        'username': username,
        'favcategories': jsonEncode(selectedCategories),
      };

      final respuesta = await http.post(
        Uri.parse('http://${ip}:8080/users/edit'),
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

  //a partir de aqui verificar si hace falta el token i adaptar el codigo
  //este token se debera cambiar por el del current user
  static const token =
      "976f2f7b53c188d8a77b9b71887621d1e1d207faec5663bf79de9572ac887ea7";

  //xat existe? si no es asi crealo
  Future<xatAmic?> xatExists(String receiverName) async {
    try {
      final respuesta = await http.get(
        Uri.parse('http://10.0.2.2:8080/xats/exists?receiverId=$receiverName'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (respuesta.statusCode == 200) {
        final data = json.decode(respuesta.body);
        if (data['exists']) {
          //El xat existe, devuelve sus detalles
          return xatAmic(
              lastMessage: data['data']['last_msg'],
              timeLastMessage: data['data']['last_time'],
              recieverId: data['data']['receiverId'],
              senderId: data['data']['senderId']);
        } else {
          return null; //El xat no existe
        }
      } else {
        throw Exception(
            'Fallo la obtención de datos: ${respuesta.statusCode}'); //Error en la solicitud HTTP
      }
    } catch (error) {
      throw Exception(
          'Fallo la obtención de datos: $error'); //Error de red u otro tipo de error
    }
  }

  Future<bool> createXat(String receiverName) async {
    try {
      final Map<String, dynamic> xatdata = {'receiverId': receiverName};

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/xats/create'),
        body: jsonEncode(xatdata),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (respuesta.statusCode == 201) {
        print('Xat creado exitosamente');
        return true;
      } else {
        print('Error al crear xat: ${respuesta.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error de red: $error');
      return false;
    }
  }

  Future<String?> getXatId(String receiver, String sender) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('xats')
          .where('receiverId', isEqualTo: receiver)
          .where('senderId', isEqualTo: sender)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot
            .docs.first.id; // Devuelve el ID del primer documento
      } else {
        return null; // Si no se encontró ningún documento
      }
    } catch (error) {
      return null; // Si ocurre algún error al obtener el ID del xat
    }
  }

  void addMessage(String? xatId, String time, String text) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/xats/$xatId/mensajes');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'mensaje': text, 'fecha': time}),
      );

      if (response.statusCode == 201) {
        print('Mensaje agregado exitosamente al xat');
      } else {
        print('Error al agregar mensaje al xat: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  Future<List<Message>> getMessages(String? xatId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/xats/$xatId/mensajes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Mapear los datos de los mensajes a una lista de objetos Message
        List<Message> mensajes =
            data.map((json) => Message.fromJson(json)).toList();
        mensajes.sort((b, a) => a.timeSended.compareTo(b.timeSended));
        return mensajes;
      } else if (response.statusCode == 404) {
        return []; // Devolver una lista vacía si no hay posts para este xat
      } else {
        throw Exception(
            'Error al obtener los posts del foro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  //get dels grups en els que es troba un usuari
  Future<List<Grup>> getUserGrups() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/grups/users/all'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Grup> reply = data.map((json) => Grup.fromJson(json)).toList();
        reply.sort((b, a) => a.timeLastMessage.compareTo(b.timeLastMessage));
        return reply;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Error al obtener los replies del post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  //get info d'un grup
  Future<Grup> getInfoGrup(String grupId) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/grups/$grupId'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        Grup reply = data.map((json) => Grup.fromJson(json)).toList();
        return reply;
      } else if (response.statusCode == 404) {
        throw Exception('grup no existeix');
      } else {
        throw Exception(
            'Error al obtener los replies del post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }

  //crear grup
  void createGrup(String name, String description, String image,
      List<String> members) async {
    try {
      final Map<String, dynamic> grupata = {
        'name': name,
        'descr': description,
        'imatge': image,
        'members': members
      };

      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:8080/grups/create'),
        body: jsonEncode(grupata),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (respuesta.statusCode == 201) {
        print('Grup creado exitosamente');
      } else {
        print('Error al crear grup: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  //actualitzar info grup
  void updateGrup(String grupId, String name, String description, String image,
      List<dynamic> members) async {
    try {
      final Map<String, dynamic> grupata = {
        'name': name,
        'descr': description,
        'imatge': image,
        'members': members
      };

      final respuesta = await http.put(
        Uri.parse('http://10.0.2.2:8080/grups/$grupId/update'),
        body: jsonEncode(grupata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 201) {
        print('Grup actualizado exitosamente');
      } else {
        print('Error al actualizar grup: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  //afegir missatge al grup
  void addGrupMessage(String grupId, String time, String text) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/grups/$grupId/mensajes');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'mensaje': text, 'fecha': time}),
      );

      if (response.statusCode == 201) {
        print('Mensaje agregado exitosamente al xat');
      } else {
        print('Error al agregar mensaje al xat: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  //agafar missatges del grup
  Future<List<Message>> getGrupMessages(String grupId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/grups/$grupId/mensajes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Mapear los datos de los mensajes a una lista de objetos Message
        List<Message> mensajes =
            data.map((json) => Message.fromJson(json)).toList();
        mensajes.sort((b, a) => a.timeSended.compareTo(b.timeSended));
        return mensajes;
      } else if (response.statusCode == 404) {
        return []; // Devolver una lista vacía si no hay posts para este grupo
      } else {
        throw Exception(
            'Error al obtener los mensajes del grupo: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }
}
