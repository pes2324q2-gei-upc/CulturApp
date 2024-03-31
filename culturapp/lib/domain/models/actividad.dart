class Actividad {
  late String name;
  late String code;
  late List<dynamic> categoria = [];
  late double latitud;
  late double longitud;
  late String imageUrl;
  late String descripcio; // Corregir aquí
  late String dataInici;
  late String dataFi;
  late String ubicacio;
  late Uri urlEntrades;
  late String preu;
  late String comarca;
  late String horari;
  late int visualitzacions;

  Actividad();

  Actividad.fromJson(Map<String, dynamic> json) {
    name = json['denominaci'];
    code = json['codi'];
    latitud = json['latitud'] != null ? double.parse(json['latitud']) : 1.0;
    longitud = json['longitud'] != null ? double.parse(json['longitud']) : 1.0;
    descripcio =
        json['descripcio'] ?? 'No hi ha cap descripció per aquesta activitat.';
    ubicacio = json['adre_a'] ?? 'No disponible';
    String tagsCategorias = json['tags_categor_es'] ?? '';

    if (tagsCategorias.contains('agenda:categories/')) {
      List<String> categoriaJSON = tagsCategorias.split(',');

      for (var cat in categoriaJSON) {
        int startIndex =
            cat.indexOf('agenda:categories/') + 'agenda:categories/'.length;
        categoria.add(cat.substring(startIndex));
      }
    } else {
      categoria = [''];
    }

    String imagenes = json['imatges'] ?? '';
    if (imagenes != '') {
      int endIndex = imagenes.indexOf(',');
      if (endIndex != -1) {
        imageUrl = "https://agenda.cultura.gencat.cat" +
            imagenes.substring(0, endIndex);
      } else {
        imageUrl = "https://agenda.cultura.gencat.cat" + imagenes;
      }
    }

    String data = json['data_inici'] ?? '';
    if (data != '') {
      dataInici = data.substring(0, 10);
    } else {
      dataInici = '-';
    }

    if (dataInici == '9999-09-09') dataInici = 'Sense Data';

    data = json['data_fi'] ?? '';
    if (data != '') {
      dataFi = data.substring(0, 10);
    } else {
      dataFi = '-';
    }

    if (dataFi == '9999-09-09') dataFi = 'Sense Data';

    String url = json['enlla_os'] ?? '';
    if (url != '') {
      int endIndex = url.indexOf(',');
      if (endIndex != -1) {
        urlEntrades = Uri.parse(url.substring(0, endIndex));
      } else {
        urlEntrades = Uri.parse(url);
      }
    }

    String entrades = json['entrades'] ?? 'Veure més informació';
    if (entrades != '') {
      int endIndex = imagenes.indexOf('€');
      if (endIndex != -1) {
        preu = entrades.substring(0, endIndex);
      } else {
        preu = entrades;
      }
    }

    horari = json['horari'] ?? "horari_nul";

    String comarcaAll = json['comarca'] ?? '-';
    if (comarcaAll.contains('agenda:ubicacions/')) {
      // Split the string on '/'
      List<String> comarcaParts = comarcaAll.split('/');

      // Take the last part of the split
      String comarcaLastPart = comarcaParts.last;

      // Replace all '-' with ' '
      String comarcaReplaced = comarcaLastPart.replaceAll('-', ' ');

      // Capitalize the first letter and make the rest of the string lowercase
      comarca = comarcaReplaced[0].toUpperCase() +
          comarcaReplaced.substring(1).toLowerCase();
    } else {
      comarca = '';
    }
  }
}
