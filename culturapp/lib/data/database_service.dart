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
  var snapshot = await db.collection('actividades').get();
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
          'denominaci': actividad.name,
          'code': actividad.code,
          'categoria': actividad.categoria,
          'latitud': actividad.latitud,
          'longitud': actividad.longitud,
          'data_inici': actividad.dataInici,
          'data_fi': actividad.dataFi,
          'horari': actividad.horari,
          'descripcio': actividad.descripcio,
          'comarca': actividad.comarca,
          'imatges': actividad.imageUrl,
          'entrades': actividad.preu,
          'adre_a': actividad.ubicacio,
          'enlla_os': actividad.urlEntrades
        };
        db.collection('actividades').doc(actividad.code).set(act);
      }
    }
  }
}

Future<List<Actividad>> getActivities() async {
  List<Actividad> activities = [];
  CollectionReference crActivity = db.collection('actividades');
  QuerySnapshot querySnapshot = await crActivity.get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    String name = data?['denominaci'];
    
    String code = data?['codi'];

    String tagsCategorias = data?['tags_categor_es'];
    print(tagsCategorias);
    String categoria = ' ';
    
    if (tagsCategorias.contains('agenda:categories/')) {
      //Obtener valor del punto en el que comienza la categoria
      int startIndex = tagsCategorias.indexOf('agenda:categories/') +
          'agenda:categories/'.length;
      //Obtener valor del punto en el que acaba la categoria
      int endIndex = tagsCategorias.indexOf(',', startIndex);
      //Coger la categoria entre punto inicio y final si ha encontrado la "," sino de inicio hasta final
      categoria = endIndex != -1
          ? tagsCategorias.substring(startIndex, endIndex)
          : tagsCategorias.substring(startIndex);
    } else {
      categoria = ' ';
    }

    print('categoria');
    print(categoria);

    double latitud = data?['latitud'].toDouble();
    double longitud = data?['longitud'].toDouble();

    print(longitud);
    print(latitud);

    String dataInici = '';
    String fecha = data?['data_inici'] ?? '';
    if (data != '') {
      dataInici = fecha.substring(0, 10);
    }
    else {
      dataInici = '-';
    }
    if (dataInici == '9999-09-09') dataInici = 'Sense Data';

    String dataFi = '';
    fecha = data?['data_fi'] ?? '';
    if (data != '') {
        dataFi = fecha.substring(0, 10);
    }
    else {
      dataFi = '-';
    }

    if (dataFi == '9999-09-09') dataFi = 'Sense Data';


    String horari = data?['horari'];
    String descripcio = data?['descripcio'];
    String comarca = data?['comarca'];
    String imagenes = data?['imatges'] ?? '';
    String imageUrl = 'No dispo';
    if (imagenes != '') {
        int endIndex = imagenes.indexOf(',');
        if (endIndex != -1) {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes.substring(0, endIndex);
        } else {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes;
        }
    }
    String preu = data?['entrades'];
    String ubicacio = data?['adre_a'];
    String url = data?['enlla_os'];
    Uri urlEntrades = Uri.parse("https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    if (url != '') {
        int endIndex = url.indexOf(',');
        if (endIndex != -1) {
            urlEntrades = Uri.parse(url.substring(0, endIndex));
        } else {
            urlEntrades = Uri.parse(url);
        }
    }

    Actividad actividad = Actividad(dataFi: dataFi ,dataInici: dataInici ,  horari: horari, latitud: latitud, longitud: longitud, descripcio: descripcio, name: name, code: code, categoria: categoria, comarca: comarca, imageUrl: imageUrl, preu: preu, urlEntrades: urlEntrades, ubicacio: ubicacio);
    
    activities.add(actividad);
  }
  return activities;
}

/*
Future<List<Actividad>> getActividadCategoria(String categoria) async {
  List<Actividad> activities = [];
  CollectionReference crActivity = db.collection('actividades');
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
  CollectionReference crActivity = db.collection('actividades');
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

    */