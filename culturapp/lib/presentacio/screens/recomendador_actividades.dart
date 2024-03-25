import 'package:culturapp/domain/models/actividad.dart';

List<String> calcularActividadesRecomendadas(List<String> categoriasFavoritas, List<Actividad> actividades) {
  List<Actividad> actividadesCategoria1 = [];
  List<Actividad> actividadesCategoria2 = [];
  List<Actividad> actividadesCategoria3 = [];

  if (categoriasFavoritas.isNotEmpty) {

  for (int i = 0; i < actividades.length; ++i) {
    if (categoriasFavoritas[0] != null && categoriasFavoritas[0] == actividades[i].categoria[0]) {
      actividadesCategoria1.add(actividades[i]);
    } else if (categoriasFavoritas[1] != null && categoriasFavoritas[1] == actividades[i].categoria[0]) {
      actividadesCategoria2.add(actividades[i]);
    } else if (categoriasFavoritas[2] != null && categoriasFavoritas[2] == actividades[i].categoria[0]) {
      actividadesCategoria3.add(actividades[i]);
    }
  }
  }


  actividadesCategoria1.sort((a, b) => b.visualitzacions.compareTo(a.visualitzacions));
  actividadesCategoria2.sort((a, b) => b.visualitzacions.compareTo(a.visualitzacions));
  actividadesCategoria3.sort((a, b) => b.visualitzacions.compareTo(a.visualitzacions));

  List<String> recomendaciones = [];
  agregarActividadesRecomendadas(actividadesCategoria1, recomendaciones);
  agregarActividadesRecomendadas(actividadesCategoria2, recomendaciones);
  agregarActividadesRecomendadas(actividadesCategoria3, recomendaciones);

  return recomendaciones;
}

void agregarActividadesRecomendadas(List<Actividad> actividades, List<String> recomendaciones) {
  for (int i = 0; i < actividades.length && i < 5; ++i) {
    recomendaciones.add(actividades[i].code);
  }
}
