import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
  late ControladorPresentacion _controladorPresentacion;


  MyApp({Key? key, required this.controladorPresentacion}) : super(key: key);

  void _onTabChange(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        body: Center(
          child: MapPage(controladorPresentacion: controladorPresentacion)
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        ),
          child: GNav(
            backgroundColor: Colors.white,
          color: Colors.orange,
          activeColor: Colors.orange,
          tabBackgroundColor: Colors.grey.shade100,
          gap: 6,
          onTabChange: (index) {
            _onTabChange(index, context);
          },
          selectedIndex: 0,
          tabs: [
            const GButton(
                text: "Mapa",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.map),
            GButton(
              text: "Mis Actividades",
              textStyle: const TextStyle(fontSize: 12, color: Colors.orange),
              icon: Icons.event,
              onPressed: () {
                Navigator.pushNamed(context, '/myActivities');
              },
            ),
            const GButton(
                text: "Chats",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.chat),
            const GButton(
                text: "Perfil",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.person),
            ],
          ),
        ),
      ),
    );
  }
  
}