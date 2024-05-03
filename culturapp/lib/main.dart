// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final controladorPresentacion = ControladorPresentacion();
  //controladorPresentacion.funcLogout();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    await controladorPresentacion.initialice();
  }
  
  runApp(MyApp(controladorPresentacion: controladorPresentacion));
}

class MyApp extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const MyApp({Key? key, required this.controladorPresentacion}) : super(key: key);

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
      supportedLocales: const [
        Locale('en'),
        Locale('ca'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (deviceLocale != null && deviceLocale.languageCode == locale.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
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
