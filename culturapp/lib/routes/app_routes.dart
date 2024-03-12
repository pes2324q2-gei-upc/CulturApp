import 'package:culturapp/actividades/lista_actividades.dart';
import 'package:culturapp/categorias_favoritas.dart/categorias.dart';
import 'package:culturapp/controlador_presentacion.dart';
import 'package:culturapp/map/map_screen.dart';
import 'package:culturapp/pages/my_activities.dart';
import 'package:culturapp/pages/search_my_activities.dart';
import 'package:culturapp/pages/login.dart';
import 'package:culturapp/pages/signup.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/perfil/perfil_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {

  Routes.map: (_) => const MapPage(),
  Routes.perfil: (_) => const PerfilPage(),
  Routes.misActividades: (_) => const MyActivities(),
  Routes.searchMisActividades: (_) => const SearchMyActivities(),
  Routes.login: (_) => const Login(),
};

