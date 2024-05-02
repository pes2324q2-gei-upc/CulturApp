// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print
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
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/xats/grups/crear_grup_screen.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
import 'package:culturapp/presentacio/screens/recomendador_actividades.dart';
import 'package:culturapp/presentacio/screens/recomendador_users.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/update_perfil.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_mis_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:culturapp/presentacio/screens/xats/amics/xat_amic.dart';
import 'package:culturapp/presentacio/screens/xats/xats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:culturapp/domain/models/foro_model.dart';
import 'package:culturapp/domain/models/post.dart';

class ControladorPresentacion {
  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user = null;
  late List<Actividad> activitats;
  late List<Actividad> activitatsUser;
  late List<String> recomms;
  late List<String> categsFav = [];
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  late List<String> friends;

  void func_logout() async {
    _auth.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); 
  }

  Future<void> initialice() async {
    activitats = await controladorDomini.getActivitiesAgenda();
    usersBD = await controladorDomini.getUsers();
  }

  Future<void> initialice2() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
    }

    if (userLogged()) {
      categsFav = await controladorDomini.obteCatsFavs(_user);
      activitatsUser = await controladorDomini.getUserActivities(_user!.uid);
      /*
      Future<String> usname = getUsername(_user!.uid);
      String username = await usname;
      friends = await controladorDomini.obteFollows(username);*/
      usersBD.removeWhere((usuario) => usuario.identificador == _user!.uid);
      //usersBD.removeWhere((usuario) => friends.contains(usuario.username));
      usersRecom = calculaUsuariosRecomendados(usersBD, _user!.uid, categsFav);
    }
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
            controladorPresentacion: this, uid: _user!.uid, owner: true),
      ),
    );
  }

  Future<void> mostrarMisActividades(BuildContext context) async {
    getUserActivities(_user!.uid).then((actividades) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaMisActividades(
                controladorPresentacion: this,
                user: _user,
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
        builder: (context) => ListaMisActividades(
          controladorPresentacion: this,
          user: _user,
        ),
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
        //Si no hi ha un usuari associat al compte de google, redirigir a la pantalla de registre
        if (!userExists) {
          mostrarSignup(context);
        }
        //Altrament redirigir a la pantalla principal de l'app
        else {
          await initialice();
          await initialice2();
          mostrarMapa(context);
        }
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

  Future<bool> createUser(String username, List<String> selectedCategories,
      BuildContext context) async {
    await controladorDomini.createUser(_user, username, selectedCategories);
    return true;
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

  void logout(BuildContext context) async {
    _auth.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); 
    Future.delayed(Duration(seconds: 2), () {
      mostrarLogin(context);
    });
  }

  Future<bool> usernameUnique(String username) {
    return controladorDomini.usernameUnique(username);
  }


  //veure si existeix el foro i si no el crea
  Future<void> getForo(String code) async {
    Foro? foro = await controladorDomini.foroExists(code);
    if (foro != null) {
      // El foro existe, imprimir sus detalles
      print('Foro existente: $foro');
    } else {
      // El foro no existe, crear uno nuevo
      bool creadoExitosamente = await controladorDomini.createForo(code);
      if (creadoExitosamente) {
          print('Nuevo foro creado');
      } else {
        print('Error al crear el foro');
      }
    }
  }

  //agafar id del foro
  Future<String?> getForoId(String activitatCode) async {
    return controladorDomini.getForoId(activitatCode);
  }

  //modificar el como se encuentra el post, maybe añadir param que sea id = username + fecha
  Future<String?> getPostId(String foroId, String data) async{
    return controladorDomini.getPostId(foroId, data);
  }

  //agafa id fe la reply
  Future<String?> getReplyId(String foroId, String? postId, String data) async{
    return controladorDomini.getReplyId(foroId, postId, data);
  }

  //afegir post a la bd
  Future<void> addPost(String foroId, String mensaje, String fecha, int numeroLikes){
    return controladorDomini.addPost(foroId, mensaje, fecha, numeroLikes);
  }

  //afegir reply a la bd
  Future<void> addReplyPost(String foroId, String postId, String mensaje, String fecha, int numeroLikes) async {
    return controladorDomini.addReplyPost(foroId, postId, mensaje, fecha, numeroLikes);
  }

  //get posts de un foro
  Future<List<Post>> getPostsForo(String foroId) async {
    return controladorDomini.getPostsForo(foroId);
  }

  //get replies de los posts
  Future<List<Post>> getReplyPosts(String foroId, String? postId) async {
    return controladorDomini.getReplyPosts(foroId, postId);
  }

  //eliminar post
  Future<void> deletePost(String foroId, String? postId) async {
    return controladorDomini.deletePost(foroId, postId);
  }

  //eliminar reply
  Future<void> deleteReply(String foroId, String? postId, String? replyId) async {
    return controladorDomini.deleteReply(foroId, postId, replyId);
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
