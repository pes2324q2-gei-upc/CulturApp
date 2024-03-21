import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart'; // Assuming this screen exists
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final controladorPresentacion = ControladorPresentacion();
  await controladorPresentacion.initialice();
  
  runApp(MyApp(controladorPresentacion: controladorPresentacion));
}

class MyApp extends StatefulWidget {
   final ControladorPresentacion controladorPresentacion;

   MyApp({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      if (index != 2){
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        body: widget.controladorPresentacion.getPage(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
          ),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 245, 242, 242),
            color: Colors.orange,
            activeColor: Colors.orange,
            tabBackgroundColor: Colors.grey.shade300,
            gap: 6,
            onTabChange: _onTabChange,
            selectedIndex: _selectedIndex,
            tabs: const [
              GButton(
                text: "Mapa",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.map,
              ),
              GButton(
                text: "Mis Actividades",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.event,
              ),
              GButton(
                text: "Chats",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.chat,
              ),
              GButton(
                text: "Perfil",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
