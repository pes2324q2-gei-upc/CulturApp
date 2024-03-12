import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:http/http.dart' as http;
FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuaris() async {
  List usuaris = [];
  CollectionReference crUsuaris = db.collection('Usuari');
  QuerySnapshot qeUsuaris = await crUsuaris.get();
  for (var doc in qeUsuaris.docs) {
    usuaris.add(doc.data());
  }
  return usuaris;
}

Future<void> insertActivities() async {
  var snapshot = await db.collection('activity').get();
  var numElementos = snapshot.docs.length;
  // Insertar datos solo si la colección 'activity' tiene más de dos elementos
  if (numElementos < 2) {
    var url = Uri.parse(
        "https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        final act = <String, dynamic>{
          'name': actividad.name,
          'code': actividad.code,
          'categoria': actividad.categoria,
          'latitud': actividad.latitud,
          'longitud': actividad.longitud,
          'data_inici': actividad.data_inici,
          'data_fi': actividad.data_fi,
          'horari': actividad.horari,
          'descripcio': actividad.descripcio,
          'comarca': actividad.comarca,
          'imageUrl': actividad.imageUrl,
          'preu': actividad.preu,
          'ubicacio': actividad.ubicacio,
          'urlEntrades': actividad.urlEntrades
        };
        db.collection('activity').doc(actividad.code).set(act);
      }
    }
  }
}

Future<List<Actividad>> getActivities() async {
  List<Actividad> activities = [];
  CollectionReference crActivity = db.collection('activity');
  QuerySnapshot querySnapshot = await crActivity.limit(20).get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    String? name = data?['name'];
    String? code = data?['code'];
    String? categoria = data?['categoria'];
    double? latitud = data?['latitud'];
    double? longitud = data?['longitud'];
    Timestamp? timestamp = data?['data_inici'];
    DateTime? data_inici = timestamp != null ? timestamp.toDate() : null;
    timestamp = data?['data_fi'];
    DateTime? data_fi = timestamp != null ? timestamp.toDate() : null;
    String? horari = data?['horari'];
    String? descripcio = data?['descripcio'];
    String? comarca = data?['comarca'];
    String? imageUrl = data?['imageUrl'];
    String? preu = data?['preu'];
    String? ubicacio = data?['ubicacio'];
    String? urlEntrades = data?['urlEntrades'];
    Actividad actividad = Actividad(name, code, categoria, latitud, longitud, data_inici, data_fi, horari, descripcio, comarca, imageUrl, preu, ubicacio, urlEntrades);
    activities.add(actividad);
  }
  return activities;
}


Future<List<Actividad>> getActividadCategoria(String categoria) async {
  List<Actividad> activities = [];
  CollectionReference crActivity = db.collection('activity');            
  QuerySnapshot querySnapshot = await crActivity
                                  .where('categoria', isEqualTo: categoria)
                                  .get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    String? name = data?['name'];
    String? code = data?['code'];
    String? categoria = data?['categoria'];
    double? latitud = data?['latitud'];
    double? longitud = data?['longitud'];
    Timestamp? timestamp = data?['data_inici'];
    DateTime? data_inici = timestamp != null ? timestamp.toDate() : null;
    timestamp = data?['data_fi'];
    DateTime? data_fi = timestamp != null ? timestamp.toDate() : null;
    String? horari = data?['horari'];
    String? descripcio = data?['descripcio'];
    String? comarca = data?['comarca'];
    String? imageUrl = data?['imageUrl'];
    String? preu = data?['preu'];
    String? ubicacio = data?['ubicacio'];
    String? urlEntrades = data?['urlEntrades'];
    Actividad actividad = Actividad(name, code, categoria, latitud, longitud, data_inici, data_fi, horari, descripcio, comarca, imageUrl, preu, ubicacio, urlEntrades);
    activities.add(actividad);
  }
  return activities;
}

Future<List<Actividad>> getActividadData(DateTime date) async {
  List<Actividad> activities = [];
  CollectionReference crActivity = db.collection('activity');           
  QuerySnapshot querySnapshot = await crActivity
                                  .where('data', isEqualTo: date)
                                  .get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    String? name = data?['name'];
    String? code = data?['code'];
    String? categoria = data?['categoria'];
    double? latitud = data?['latitud'];
    double? longitud = data?['longitud'];
    Timestamp? timestamp = data?['data_inici'];
    DateTime? data_inici = timestamp != null ? timestamp.toDate() : null;
    timestamp = data?['data_fi'];
    DateTime? data_fi = timestamp != null ? timestamp.toDate() : null;
    String? horari = data?['horari'];
    String? descripcio = data?['descripcio'];
    String? comarca = data?['comarca'];
    String? imageUrl = data?['imageUrl'];
    String? preu = data?['preu'];
    String? ubicacio = data?['ubicacio'];
    String? urlEntrades = data?['urlEntrades'];
    Actividad actividad = Actividad(name, code, categoria, latitud, longitud, data_inici, data_fi, horari, descripcio, comarca, imageUrl, preu, ubicacio, urlEntrades);
    activities.add(actividad);
  }
  return activities;
}


//Ejemplos de codigos que llaman a alguna función de este tipo desde el builder
 
/*import 'package:culturapp/services/firebase_service.dart';

body:FutureBuilder( 
      future: getUsuaris(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ,
            itemBuilder: (context, index) {
              return Text(snapshot.data?[index]['nomusuari']);
           // return Text(snapshot.data?[index]['email']),
            },
          );
        } 
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    ),*/