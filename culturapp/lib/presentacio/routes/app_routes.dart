import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/categorias.dart';
import 'package:culturapp/presentacio/controlador_presentacion.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/screens/search_my_activities.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  //Routes.map: (_) => const MapPage(),
  Routes.listaActividades: (_) => const ListaActividades(),
  Routes.perfil: (_) => const PerfilPage(),

  Routes.misActividades: (_) => const MyActivities(),
  Routes.searchMisActividades: (_) => const SearchMyActivities(),
  Routes.login: (_) => const Login(),
};
