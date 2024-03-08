class Actividad {
  late String name;
  late String code;
  late String categoria;
  late double latitud;
  late double longitud;
  late String imageUrl;
  late String description;
  late String dataInici;

  Actividad(this.name, this.code);

  Actividad.fromJson(Map<String, dynamic> json) {
    name = json['denominaci'];
    code = json['codi'];
    latitud = json['latitud'] != null ? double.parse(json['latitud']) : 1.0;
    longitud = json['longitud'] != null ? double.parse(json['longitud']) : 1.0;
    description = json['descripcio'] ?? 'No hi ha cap descripció per aquesta activitat.';
    
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

    String imagenes = json['imatges'] ?? '';
    if (imagenes != '') {
        int endIndex = imagenes.indexOf(',');
        if (endIndex != -1) {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes.substring(0, endIndex);
        } else {
            imageUrl = "https://agenda.cultura.gencat.cat" + imagenes;
        }
    }

    String data = json['imatges'] ?? '';
    if (data != '') {
        int endIndex = imagenes.indexOf('T');
        if (endIndex != -1) {
        dataInici = data.substring(0, endIndex);
        }
        else {
            dataInici = '-';
        }
    }
      
  }
}