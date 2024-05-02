import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/grup.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/screens/edit_perfil.dart';
import 'package:culturapp/presentacio/screens/xats/amics/info_amic.dart';
import 'package:culturapp/presentacio/screens/xats/grups/configuracio_grup.dart';
import 'package:culturapp/presentacio/screens/xats/grups/info_grup.dart';
import 'package:culturapp/presentacio/screens/xats/grups/modificar_participants.dart';
import 'package:culturapp/presentacio/screens/xats/grups/xat_grup.dart';
import 'package:culturapp/domain/models/user.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/xats/grups/crear_grup_screen.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
import 'package:culturapp/presentacio/screens/recomendador_actividades.dart';
import 'package:culturapp/presentacio/screens/recomendador_users.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_mis_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:culturapp/presentacio/screens/xats/amics/xat_amic.dart';
import 'package:culturapp/presentacio/screens/xats/xats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ControladorPresentacion {
  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late List<Actividad> activitats;
  late List<String> recomms;
  late List<String> categsFav = [];
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  late List<String> friends;
  late String usernameLogged;

  void funcLogout() async {
    _auth.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); 
  }

  Future<void> initialice() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;

      await controladorDomini.setInfoUserLogged(_user!.uid);
      usernameLogged = controladorDomini.userLogged.getUsername();

      activitats = await controladorDomini.getActivitiesAgenda();
      usersBD = await controladorDomini.getUsers();

      categsFav = await controladorDomini.obteCatsFavs(); 
      usersBD.removeWhere((usuario) => usuario.username == usernameLogged);
      usersRecom = calculaUsuariosRecomendados(usersBD, usernameLogged, categsFav);
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        bool userExists =
            await controladorDomini.accountExists(userCredential.user);
        _user = userCredential.user;
  
        if (!userExists) {
          mostrarSignup(context);
        }
        else {
          await initialice();
          mostrarMapa(context);
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool> createUser(String username, List<String> selectedCategories,
      BuildContext context) async {
    await controladorDomini.createUser(_user, username, selectedCategories);
    return true;
  }

  void editUser(String username, List<String> selectedCategories,
      BuildContext context) async { //FALTA AÑADIR SISTEMA TOKENS
    controladorDomini.editUser(_user, username, selectedCategories);
    categsFav = selectedCategories;
    mostrarPerfil(context);
  }

  void checkLoggedInUser(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      _user = currentUser;
      controladorDomini.setInfoUserLogged(_user!.uid);
      usernameLogged = controladorDomini.userLogged.getUsername();
      mostrarMapa(context);
    }
  }

  void logout(BuildContext context) async {
    _auth.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); 
    Future.delayed(const Duration(seconds: 2), () {
      mostrarLogin(context);
    });
  }

  Future<bool> usernameUnique(String username) {
    return controladorDomini.usernameUnique(username);
  }

  List<String> getCategsFav() {
    return categsFav;
  }

  Future<List<Actividad>> getUserActivities() => controladorDomini.getUserActivities();

  List<Actividad> getActivitats() => activitats;

  List<String> getActivitatsRecomm() {
    recomms = calcularActividadesRecomendadas(categsFav, activitats);
    return recomms;
  }

  User? getUser() {
    return _user;
  }

  Future<List<Actividad>> searchActivitat(String squery) {
    return controladorDomini.searchActivitat(squery);
  }

  Future<List<Actividad>> searchMyActivitats(String name) {
    return controladorDomini.searchMyActivities(usernameLogged, name);
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
          recomms: usersRecom,
          usersBD: usersBD,
        ),
      ),
    );
  }

  void mostrarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerfilPage(
            controladorPresentacion: this, username: usernameLogged, owner: true),
      ),
    );
  }

  Future<void> mostrarMisActividades(BuildContext context) async {
    getUserActivities().then((actividades) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaMisActividades(
                controladorPresentacion: this,
                user: _user, //NECESITA USER
              ),
            ),
          )
        });
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
        builder: (context) => ListaMisActividades(
          controladorPresentacion: this,
          user: _user, //NECESITA USER
        ),
      ),
    );
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

  void mostrarInfoAmic(BuildContext context, Usuari usuari) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InfoAmicScreen(controladorPresentacion: this, usuari: usuari),
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

  void mostrarEditPerfil(BuildContext context, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditPerfil(controladorPresentacion: this, username: username),
      ),
    );
  }
}
