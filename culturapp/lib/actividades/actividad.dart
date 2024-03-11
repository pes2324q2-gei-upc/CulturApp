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

  Actividad(this.name, this.code, this.categoria, this.latitud, this.longitud, this.data_inici, this.data_fi, this.horari, this.descripcio);

  Actividad.fromJson(Map<String, dynamic> json) {
    name = json['denominaci'] != null ? json['denominaci'] : "nom nul";
    code = json['codi'] != null ? json['codi'] : "codi_nul";
    latitud = json['latitud'] is double ? json['latitud'] : 1.0;
    longitud = json['longitud'] is double ? json['longitud'] : 1.0;
    data_inici = json['data_inici'] != null ? (json['data_inici'] as Timestamp).toDate(): DateTime.now();
    data_fi = json['data_fi'] != null ? (json['data_fi'] as Timestamp).toDate(): DateTime.now();
    horari = json['horari'] != null ? json['horari'] : "horari_nul";
    descripcio = json['descripcio'] != null ? json['descripcio'] : "descripcio_nul";

    String tagsCategorias = json['tags_categor_es'] ?? '';

    if (tagsCategorias.contains('agenda:categories/')) {
      //Obtener valor del punto en el que comienza la categoria
      int startIndex = tagsCategorias.indexOf('agenda:categories/') + 'agenda:categories/'.length;
      //Obtener valor del punto en el que acaba la categoria
      int endIndex = tagsCategorias.indexOf(',', startIndex);
      //Coger la categoria entre punto inicio y final si ha encontrado la "," sino de inicio hasta final
      categoria = endIndex != -1 ? tagsCategorias.substring(startIndex, endIndex) : tagsCategorias.substring(startIndex);
    } else {
      categoria = ' ';
    }
  }
}