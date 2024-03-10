import 'package:culturapp/map/map_screen.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/perfil/perfil_screen.dart';


Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.map: (_) => const MapPage(),
  Routes.perfil: (_) => const PerfilPage()
};