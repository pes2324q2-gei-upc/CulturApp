import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/grup.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/screens/edit_perfil.dart';
import 'package:culturapp/presentacio/screens/xats/grups/configuracio_grup.dart';
import 'package:culturapp/presentacio/screens/xats/grups/info_grup.dart';
import 'package:culturapp/presentacio/screens/xats/grups/modificar_participants.dart';
import 'package:culturapp/presentacio/screens/xats/grups/xat_grup.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/screens/xats/grups/crear_grup_screen.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
import 'package:culturapp/presentacio/screens/recomendador_actividades.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_mis_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:culturapp/presentacio/screens/xats/xat_amic.dart';
import 'package:culturapp/presentacio/screens/xats/xats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ControladorPresentacion {
  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late List<Actividad> activitats;
  late List<Actividad> activitatsUser;
  late List<String> recomms;
  late List<String> categsFav = [];
  late final List<Widget> _pages = [];

  Future<void> initialice() async {
    activitats = await controladorDomini.getActivitiesAgenda();
  }

  Future<void> initialice2() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
    }

    if (userLogged()) {
      categsFav = await controladorDomini.obteCatsFavs(_user);
      activitatsUser = await controladorDomini.getUserActivities(_user!.uid);
    }

    _pages.addAll([
      MapPage(controladorPresentacion: this),
      ListaMisActividades(
        controladorPresentacion: this,
      ),
      Xats(
        controladorPresentacion: this,
      ),
      PerfilPage(controladorPresentacion: this, uid: _user!.uid),
    ]);
  }

  bool userLogged() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      return true;
    } else {
      return false;
    }
  }

  void mostrarVerActividad(
      BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(
          info_actividad: info_act,
          uri_actividad: uri_act,
          controladorPresentacion: this,
        ),
      ),
    );
  }

  void mostrarMapa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(controladorPresentacion: this),
      ),
    );
  }

  void mostrarXats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Xats(
          controladorPresentacion: this,
        ),
      ),
    );
  }

  void mostrarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PerfilPage(controladorPresentacion: this, uid: _user!.uid),
      ),
    );
  }

  Widget getPage(int index) {
    return _pages[index];
  }

  Future<void> mostrarMisActividades(BuildContext context) async {
    getUserActivities(_user!.uid).then((actividades) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaMisActividades(
                controladorPresentacion: this,
              ),
            ),
          )
        });
  }

  Future<List<Actividad>> getMisActivitats() async {
    activitatsUser = await controladorDomini.getUserActivities(_user!.uid);
    return activitatsUser;
  }

  void mostrarActividades(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaActividadesDisponibles(
          actividades: activitats,
          controladorPresentacion: this,
        ),
      ),
    );
  }

  void mostrarActividadesUser(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ListaMisActividades(controladorPresentacion: this),
      ),
    );
  }

  List<Actividad> getActivitats() => activitats;

  List<Actividad> getActivitatsUser() => activitatsUser;

  List<String> getActivitatsRecomm() {
    recomms = calcularActividadesRecomendadas(categsFav, activitats);
    return recomms;
  }

  Future<List<Actividad>> getUserActivities(String userID) =>
      controladorDomini.getUserActivities(userID);

  FirebaseAuth getFirebaseAuth() {
    return _auth;
  }

  void setUser(User? event) async {
    _user = event;
  }

  User? getUser() {
    return _user;
  }

  Future<List<Actividad>> searchActivitat(String squery) {
    return controladorDomini.searchActivitat(squery);
  }

  Future<List<Actividad>> searchMyActivitats(String name) {
    return controladorDomini.searchMyActivities(_user!.uid, name);
  }

  void checkLoggedInUser(BuildContext context) {
    //Obte l'usuari autentificat en el moment si existeix
    User? currentUser = _auth.currentUser;

    //Si existeix l'usuari, estableix l'usuari de l'estat i redirigeix a la pantalla principal
    if (currentUser != null) {
      _user = currentUser;
      mostrarMapa(context);
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      print("HAndleando signin");
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists =
          await controladorDomini.accountExists(userCredential.user);
      _user = userCredential.user;
      //Si no hi ha un usuari associat al compte de google, redirigir a la pantalla de registre
      if (!userExists) {
        mostrarSignup(context);
      }
      //Altrament redirigir a la pantalla principal de l'app
      else {
        mostrarMapa(context);
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

  void createUser(String username, List<String> selectedCategories,
      BuildContext context) async {
    controladorDomini.createUser(_user, username, selectedCategories);
    mostrarPerfil(context);
  }

  void mostrarCrearNouGrup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearGrupScreen(controladorPresentacion: this),
      ),
    );
  }

  void mostrarConfigGrup(BuildContext context, List<Usuari> participants) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfigGrup(
            controladorPresentacion: this, participants: participants),
      ),
    );
  }

  void mostrarXatGrup(BuildContext context, Grup grup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            XatGrupScreen(controladorPresentacion: this, grup: grup),
      ),
    );
  }

  void mostrarInfoGrup(BuildContext context, Grup grup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InfoGrupScreen(controladorPresentacion: this, grup: grup),
      ),
    );
  }

  void mostrarModificarParticipants(BuildContext context, Grup grup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModificarParticipantsScreen(
            controladorPresentacion: this, grup: grup),
      ),
    );
  }

  void mostrarXatAmic(BuildContext context, Usuari usuari) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => XatAmicScreen(
          controladorPresentacion: this,
          usuari: usuari,
        ),
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
    Future.delayed(Duration(seconds: 2), () {
      mostrarLogin(context);
    });
  }

  Future<bool> usernameUnique(String username) {
    return controladorDomini.usernameUnique(username);
  }

  Future<String> getUsername(String uid) {
    return controladorDomini.getUsername(uid);
  }

  void mostrarEditPerfil(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditPerfil(controladorPresentacion: this, uid: uid),
      ),
    );
  }

  List<String> getCategsFav() {
    return categsFav;
  }

  void editUser(String username, List<String> selectedCategories,
      BuildContext context) async {
    controladorDomini.editUser(_user, username, selectedCategories);
    categsFav = selectedCategories;
    mostrarPerfil(context);
  }
}
