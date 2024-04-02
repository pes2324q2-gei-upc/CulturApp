import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final controladorPresentacion = ControladorPresentacion();
  await controladorPresentacion.initialice();
  await controladorPresentacion.initialice2();
  
  runApp(MyApp(controladorPresentacion: controladorPresentacion));
}

class MyApp extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  MyApp({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(controladorPresentacion);
}

class _MyAppState extends State<MyApp> {
  late ControladorPresentacion _controladorPresentacion; 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  _MyAppState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
    // Llamar a userLogged al inicio
    userLogged();
  }

  void userLogged() {
    User? currentUser = _auth.currentUser;
    setState(() {
      _isLoggedIn = currentUser != null;
      _selectedIndex = _isLoggedIn ? _selectedIndex : 4; // Si no está logueado, selecciona el índice 4
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
        body: _isLoggedIn
            ? MapPage(controladorPresentacion: _controladorPresentacion)
            : Login(
                controladorPresentacion: _controladorPresentacion,
              ),
      ),
    );
  }
  
}
