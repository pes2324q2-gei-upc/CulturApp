import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/presentacio/routes/app_routes.dart';
import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/data/database_service.dart';

import '../data/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  await insertActivities();
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.listaActividades, //Esta puesto el mapa como pagina principal por defecto, esto se puede cambiar
      routes: appRoutes,
    );
  }
}