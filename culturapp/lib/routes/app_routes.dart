import 'package:culturapp/map/map_screen.dart';
import 'package:culturapp/pages/my_activities.dart';
import 'package:culturapp/pages/login.dart';
import 'package:culturapp/pages/signup.dart';
import 'package:culturapp/perfil/settings_perfil.dart';
import 'package:culturapp/perfil/update_perfil.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/perfil/perfil_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.map: (_) => const MapPage(),
  Routes.perfil: (_) => const PerfilPage(),
  Routes.updatePerfil: (_) => const UpdatePerfil(),
  Routes.settings: (_) => const SettingsPerfil(),
  Routes.misActividades: (_) => const MyActivities(),
  Routes.login: (_) => const Login(),
};

