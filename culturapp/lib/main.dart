import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crea la instancia del controlador después de la inicialización de Firebase
  final controladorPresentacion = ControladorPresentacion();

  await controladorPresentacion.initialice();
  // Inicia la aplicación
  runApp(MyApp(controladorPresentacion: controladorPresentacion));
}

class MyApp extends StatelessWidget {
  final ControladorPresentacion controladorPresentacion;

  MyApp({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Login(controladorPresentacion: controladorPresentacion),
    );
  }
  
}