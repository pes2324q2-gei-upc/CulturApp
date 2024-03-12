import 'package:cloud_firestore/cloud_firestore.dart';

class Actividad {
  late String? name;
  late String? code;
  late String? categoria;
  late double? latitud;
  late double? longitud;
  late DateTime? data_inici;
  late DateTime? data_fi;
  late String? horari;
  late String? descripcio;
  late String? imageUrl;
  late String? ubicacio;
  late String? urlEntrades;
  late String? preu;
  late String? comarca;

  Actividad(this.name, this.code, this.categoria, this.latitud, this.longitud, this.data_inici, this.data_fi, this.horari, this.descripcio, this.comarca, this.imageUrl, this.preu, this.ubicacio, this.urlEntrades);

  Actividad.fromJson(Map<String, dynamic> json) {
    name = json['denominaci'] != null ? json['denominaci'] : "nom nul";
    code = json['codi'] != null ? json['codi'] : "codi_nul";
    latitud = json['latitud'] is double ? json['latitud'] : 1.0;
    longitud = json['longitud'] is double ? json['longitud'] : 1.0;
    data_inici = json['data_inici'] != null && json['data_inici'] is String
    ? DateTime.parse(json['data_inici'])
    : DateTime.now();
    data_fi = json['data_fi'] != null && json['data_fi'] is String
    ? DateTime.parse(json['data_fi'])
    : DateTime.now();
    horari = json['horari'] != null ? json['horari'] : "horari_nul";
    descripcio = json['descripcio'] != null ? json['descripcio'] : "descripcio_nul";

    categoria = json['tags_categor_es'] ?? '';
  
    String comarcaAll = json['comarca'] ?? '-';
    if(comarcaAll.contains('agenda:ubicacions/')) {
      // Split the string on '/'
      List<String> comarcaParts = comarcaAll.split('/');
      
      // Take the last part of the split
      String comarcaLastPart = comarcaParts.last;
      
      // Replace all '-' with ' '
      String comarcaReplaced = comarcaLastPart.replaceAll('-', ' ');
      
      // Capitalize the first letter and make the rest of the string lowercase
      comarca = comarcaReplaced[0].toUpperCase() + comarcaReplaced.substring(1).toLowerCase();
    } else {
      comarca = '';
    }
 
  /* String tagsCategorias = json['tags_categor_es'] ?? '';
    if (tagsCategorias.contains('agenda:categories/')) {
      //Obtener valor del punto en el que comienza la categoria
      int startIndex = tagsCategorias.indexOf('agenda:categories/') + 'agenda:categories/'.length;
      //Obtener valor del punto en el que acaba la categoria
      int endIndex = tagsCategorias.indexOf(',', startIndex);
      //Coger la categoria entre punto inicio y final si ha encontrado la "," sino de inicio hasta final
      categoria = endIndex != -1 ? tagsCategorias.substring(startIndex, endIndex) : tagsCategorias.substring(startIndex);
    } else {
      categoria = ' ';
    }*/

    String imagenes = json['imatges'] ?? '';
    if (imagenes != '') {
        int endIndex = imagenes.indexOf(',');
        if (endIndex != -1) {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes.substring(0, endIndex);
        } else {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes;
        }
    }
    urlEntrades = json['enlla_os'] ?? '';

    String entrades = json['entrades'] ?? 'Veure més informació';
    if (entrades != '') {
        int endIndex = imagenes.indexOf('€');
        if (endIndex != -1) {
            preu = entrades.substring(0, endIndex);
        } else {
            preu = entrades;
        }
    }
    else preu = 'Gratuit';
    ubicacio = json['adre_a'] ?? '';

  }
}