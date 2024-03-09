import 'package:culturapp/routes/app_routes.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:culturapp/actividades/lista_actividades.dart';
import 'package:culturapp/actividades/actividad.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/listaActividades': (context) => ListaActividades(),
        // Add other routes if necessary
      },
      initialRoute: '/listaActividades',
    );
  }
}
