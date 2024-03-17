import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';

class ControladorPresentacion {

  final controladorDomini = ControladorDomini();

  late final List<Actividad> activitats;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  Future <void> initialice() async => activitats = await controladorDomini.getActivitiesAgenda(); 

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  Future<void> mostrarMisActividades(BuildContext context, String userID) async { 
      getUserActivities(userID).then((actividades) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListaActividades(actividades: actividades,),
          ),
        )
      }
    );
  }

  void mostrarActividades(BuildContext context, String userID) async { 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaActividades(actividades: activitats,),
        ),
      );
  }

  void mostrarMapaActividades(BuildContext context) async { 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(controladorPresentacion: this,),
        ),
      );
  }

  List<Actividad> getActivitats() => activitats;

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

  void checkLoggetInUser(BuildContext context) {
     //Obte l'usuari autentificat en el moment si existeix
    User? currentUser = _auth.currentUser;
    
    //Si existeix l'usuari, estableix l'usuari de l'estat i redirigeix a la pantalla principal
    if (currentUser != null) {
      _user = currentUser;
      mostrarMapaActividades(context);
    }
  }

  handleGoogleSignIn(BuildContext context) async {
    try {
      //Iniciar la sessio amb el compte especificat per l'usuari
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists = await controladorDomini.accountExists(userCredential.user);
      _user = userCredential.user;
      
      //Si no hi ha un usuari associat al compte de google, redirigir a la pantalla de registre
      if (!userExists) { mostrarSignup(context);}
      //Altrament redirigir a la pantalla principal de l'app
      else mostrarMapaActividades(context);
    }
    catch (error) {
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

  void logout(context) {
    _auth.signOut();
    mostrarLogin(context);
  }

}
