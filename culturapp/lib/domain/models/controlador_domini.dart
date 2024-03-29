import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/foro_model.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;


class ControladorDomini {
  final String ip = "10.0.2.2";
  
  Future<List<Actividad>> getActivitiesAgenda() async {
    final respuesta = await http.get(Uri.parse('http://${ip}:8080/read/all'));

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

 Future<List<Actividad>> getUserActivities(String userID) async {
    final respuesta = await http.get(
      Uri.parse('http://${ip}:8080/user/activitats/$userID'),
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchMyActivities(String userID, String name) async {
    final respuesta = await http.get(
      Uri.parse('http://10.0.2.2:8080/user/activitats/$userID/search/$name'),
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
        await http.get(Uri.parse('http://10.0.2.2:8080/activitats/name/$squery'));

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
    final respuesta = await http.get(Uri.parse('http://10.0.2.2:8080/user/exists?uid=${user?.uid}'));
    
    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "exists");
    }
    else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> obteCatsFavs(User? user) async {
    final respuesta = await http
        .get(Uri.parse('http://10.0.2.2:8080/users/${user?.uid}/favcategories'));
    List<String> categorias = [];

    if (respuesta.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(respuesta.body);
      categorias = jsonResponse.cast<String>();
    }
    return categorias;
  }

  void createUser(User? _user, String username, List<String> selectedCategories) async {
    try {
      final Map<String, dynamic> userdata = {
        'uid': _user?.uid,
        'username': username,
        'email': _user?.email,
        'favcategories': jsonEncode(selectedCategories),
      };

      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:8080/users/create'),
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


  //foro existe? si no es asi crealo
  /*
  Future<bool> foroExists(Actividad activitat) async {
    final respuesta = await http.get(Uri.parse('http://10.0.2.2:8080/foros/exists?activitat_code=${activitat.code}')); //editarlo por el codigo de la actividad
    
    if (respuesta.statusCode == 200) {
      final data = json.decode(respuesta.body);

      print(respuesta);
      return (respuesta.body == "exists");
    }
    else {
      //si no existe crear foro
      throw Exception('Fallo la obtención de datos');
    }
  }
  */

  Future<Foro?> foroExists(String code) async {
    try {
      final respuesta = await http.get(Uri.parse('http://10.0.2.2:8080/foros/exists?activitat_code=${code}'));

      if (respuesta.statusCode == 200) {
        final data = json.decode(respuesta.body);
        if (data['exists']) {
          // El foro existe, devuelve sus detalles
          return Foro(
          activitat_code: data['data']['activitat_code'],
          num_comentaris: data['data']['num_comentaris'],
          posts: List<Post>.from(data['data']['posts'].map((post) => Post.fromJson(post))),
        );
        } else {
          // El foro no existe
          return null;
        }
      } else {
        // Si hay un error en la solicitud HTTP
        throw Exception('Fallo la obtención de datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      // Si hay un error de red u otro tipo de error
      throw Exception('Fallo la obtención de datos: $error');
    }
  }

  Future<bool> createForo(String code) async {
    try {
      final Map<String, dynamic> forodata = {
        //'num_comentaris' : 0,
        'activitat_code': code,
        //'posts': [],
      };

      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:8080/foros/create'),
        body: jsonEncode(forodata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 201) {  
        print('Foro creado exitosamente');
        return true; 
      } else {
        print('Error al crear el foro: ${respuesta.statusCode}');
        return false; // Indica que ocurrió un error al crear el foro
      }
    } catch (error) {
      print('Error de red: $error');
      return false; // Indica que ocurrió un error al crear el foro
    }
  }
 

  //crear post
  Future<void> addPost(String message) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final DateTime data = DateTime.now();
    
    Post newPost = Post(
      userId: currentUserId,
      message: message, 
      date: data,
      likes: 0,
    );

    //no se si es necesaria esta parte
    return FirebaseFirestore.instance
        .collection('foro')
        .add(<String, dynamic>{
      'message': message,
      'date': DateTime.now().millisecondsSinceEpoch,
      //'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

}