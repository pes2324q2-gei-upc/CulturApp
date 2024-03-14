import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacion.dart';
import 'package:culturapp/presentacio/routes/app_routes.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ControladorPresentacion controladorPresentacion = ControladorPresentacion();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MapPage(controladorPresentacion: controladorPresentacion),
      routes: appRoutes,
    );
  }
}