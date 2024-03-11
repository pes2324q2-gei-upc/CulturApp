class Actividad {
  late String name;
  late String code;
  late String categoria;
  late double latitud;
  late double longitud;
  late DateTime data_inici;
  late DateTime data_fi;

  Actividad(this.name, this.code);

  Actividad.fromJson(Map<String, dynamic> json) {
    name = json['denominaci'];
    code = json['codi'];
    latitud = json['latitud'] != null ? double.parse(json['latitud']) : 1.0;
    longitud = json['longitud'] != null ? double.parse(json['longitud']) : 1.0;
    //data_inici = json['data_inici'] != null ? double.parse(json['data_inici']) : 1.0;
    //data_fi = json['data_fi'] != null ? double.parse(json['data_fi']) : 1.0;
    
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