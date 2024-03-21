import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
import 'package:culturapp/presentacio/screens/recomendador_actividades.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ControladorPresentacion {
  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late List<Actividad> activitats;
  late List<String> recomms;
  final List<String> categsFav = ['carnavals', 'concerts', 'conferencies'];
  late final List<Widget> _pages = [];

Future<void> initialice() async {
   activitats = await controladorDomini.getActivitiesAgenda();

  _pages.addAll([
    MapPage(controladorPresentacion: this),
    MyActivities(),
    ListaActividades(actividades: activitats), // Esta línea se agregó para inicializar ListaActividades con las actividades obtenidas
    PerfilPage(controladorPresentacion: this),
  ]);
 
}

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  Widget getPage(int index) {
    return _pages[index];
  }


  Future<void> mostrarMisActividades(BuildContext context, String userID) async {
    getUserActivities(userID).then(
      (actividades) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaActividades(actividades: actividades),
          ),
        );
      },
    );
  }

  void mostrarActividades(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaActividades(actividades: activitats),
      ),
    );
  }

  void mostrarMapaActividades(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(controladorPresentacion: this),
      ),
    );
  }

  List<Actividad> getActivitats() => activitats;

  List<String> getActivitatsRecomm() {
    recomms = calcularActividadesRecomendadas(categsFav, activitats);
    return recomms;
  }

  Future<List<Actividad>> getUserActivities(String userID) => controladorDomini.getUserActivities(userID);

  FirebaseAuth getFirebaseAuth() {
    return _auth;
  }

  void setUser(User? event) {
    _user = event;
  }

  User? getUser() {
    return _user;
  }

  void checkLoggedInUser(BuildContext context) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      mostrarMapaActividades(context);
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists = await controladorDomini.accountExists(userCredential.user);
      _user = userCredential.user;
      if (!userExists) {
        mostrarSignup(context);
      } else {
        mostrarMapaActividades(context);
      }
    } catch (error) {
      print(error);
    }
  }

  void mostrarSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Signup(controladorPresentacion: this),
      ),
    );
  }

  void mostrarLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(controladorPresentacion: this),
      ),
    );
  }

  void createUser(String username, List<String> selectedCategories, BuildContext context) async {
    controladorDomini.createUser(_user, username, selectedCategories);
    mostrarPerfil(context);
  }

  void mostrarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerfilPage(controladorPresentacion: this),
      ),
    );
  }

  void mostrarSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPerfil(controladorPresentacion: this),
      ),
    );
  }

  void logout(BuildContext context) {
    _auth.signOut();
    mostrarLogin(context);
  }
}
