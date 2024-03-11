import 'package:culturapp/actividades/lista_actividades.dart';
import 'package:culturapp/categorias_favoritas.dart/categorias.dart';
import 'package:culturapp/map/map_screen.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:flutter/material.dart';


Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.map: (_) => const MapPage(),
  Routes.actividades: (_) => const ListaActividades(),
  Routes.categorias: (_) => const Categorias()
};