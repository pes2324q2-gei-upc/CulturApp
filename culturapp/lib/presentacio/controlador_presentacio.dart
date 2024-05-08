import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/grup.dart';
import 'package:culturapp/domain/models/message.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/screens/edit_perfil.dart';
import 'package:culturapp/presentacio/screens/llistar_follows.dart';
import 'package:culturapp/presentacio/screens/llistar_pendents.dart';
import 'package:culturapp/presentacio/screens/report_bug.dart';
import 'package:culturapp/presentacio/screens/solicitud_organitzador.dart';
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
import '../domain/models/xat_amic.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:culturapp/domain/models/foro_model.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControladorPresentacion {
  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late List<Actividad> activitats;
  late List<String> recomms;
  late List<String> categsFav = [];
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  late Locale? _language = const Locale('en');
  Locale? get language => _language;
  late List<String> friends;
  late String usernameLogged;
  late List<Actividad> activitatsUser;
  late List<Actividad> actividadesVencidas;
  late List<String> actividadesValoradas;

  void funcLogout() async {
    _auth.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<void> initialice() async {
    activitats = await controladorDomini.getActivitiesAgenda();
    usersBD = await controladorDomini.getUsers();
    _loadLanguage();
  }

  Future<void> initialice2() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      await controladorDomini.setInfoUserLogged(_user!.uid);
    }
    if (await userLogged()) {
      await controladorDomini.setInfoUserLogged(_user!.uid);
      usernameLogged = controladorDomini.userLogged.getUsername();
      activitats = await controladorDomini.getActivitiesAgenda();
      activitatsUser = await controladorDomini.getUserActivities();
      actividadesVencidas = await controladorDomini.getActivitiesVencudes();
      usersBD = await controladorDomini.getUsers();
      friends = await getFollowingAll(usernameLogged);
      categsFav = await controladorDomini.obteCatsFavs(usernameLogged);
      actividadesValoradas = await controladorDomini.obteActsValoradas(usernameLogged);
      usersBD.removeWhere((usuario) => usuario.username == usernameLogged);
      usersRecom = calculaUsuariosRecomendados(usersBD, usernameLogged, categsFav);
      usersBD.removeWhere((usuario) => friends.contains(usuario.username));
      
    }
  }

  Future<bool> userLogged() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      await controladorDomini.setInfoUserLogged(_user!.uid);
      return true;
    } else {
      return false;
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
        print(userExists);

        if (!userExists) {
          mostrarSignup(context);
        } else {
          await initialice2();
          await initialice();
          mostrarMapa(context);
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<Usuari> getUserByName(String name) async {
    return await controladorDomini.getUserByName(name);
  }

  Future<bool> createUser(String username, List<String> selectedCategories,
      BuildContext context) async {
    await controladorDomini.createUser(_user, username, selectedCategories);
    return true;
  }

  void editUser(String username, List<String> selectedCategories,
      BuildContext context) async {
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

  List<Actividad> checkNoValoration(){
    //Valoradas -> Actividades que ha valorado el usuario
    //Vencidas -> Actividades que han pasado de fecha
    //Mis Actividades -> Actividades a las que ha ido el usuario
    //Actividades No Valoradas -> Actividades vencidas que estan en Mis Actividades pero no en Valoradas
    List<Actividad> noValoradas = [];
    for (int i = 0; i < activitatsUser.length; i++) {
      if (actividadesVencidas.any((actividad) => actividad.code == activitatsUser[i].code) && !actividadesValoradas.contains(activitatsUser[i].code) ) {
        print('TRUE');
        noValoradas.add(activitatsUser[i]);
      }
    }
    
    print('------------------noValoradas----------------------');

      print(noValoradas.length);
    

    print('-------------------actividadesValoradas---------------------');


      print(actividadesValoradas.length);

    //print(actividadesValoradas[0].name);

    print('------------------activitatsUser----------------------');


      print(activitatsUser.length);
    
    print('-------------------actividadesVencidas---------------------');


      print(actividadesVencidas.length);

    return noValoradas;
  }

  List<Actividad> getActivitatsUser() => activitatsUser;

  List<Actividad> getActivitats() => activitats;

  Future<List<Actividad>> getUserActivities() =>
      controladorDomini.getUserActivities();

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
    return controladorDomini.searchMyActivities(name);
  }

  ControladorDomini getControladorDomini() {
    return controladorDomini;
  }

  String getUsername() {
    return usernameLogged;
  }

  List<Actividad>getActividadesVencidas(){
    return actividadesVencidas;
  }

  Future<List<String>> getFollowingAll(String username) async {
    return (await controladorDomini.obteFollows(username, 'following'))
        .map((user) => user.toString())
        .toList();
  }

  Future<List<String>> getFollowUsers(String username, String type) async {
    if (type == 'followers') {
      return (await controladorDomini.obteFollows(username, 'followers'))
          .map((user) => user['user'].toString())
          .toList();
    } else if (type == 'following') {
      return (await controladorDomini.obteFollows(username, 'following'))
          .map((user) => user['friend'].toString())
          .toList();
    } else if (type == 'pending') {
      return (await controladorDomini.obteFollows(username, 'pendents'))
          .map((user) => user['user'].toString())
          .toList();
    }
    return [];
  }

  Future<List<String>> getRequestsUser() async {
    return await controladorDomini.getRequestsUser();
  }

  Future<void> acceptFriend(String person) async {
    await controladorDomini.acceptFriend(person);
  }

  Future<void> deleteFriend(String person) async {
    await controladorDomini.deleteFriend(person);
  }

  Future<void> createFriend(String person) async {
    await controladorDomini.createFriend(person);
  }

  Future<int> sendReportBug(String titol, String report) async {
    return await controladorDomini.sendReportBug(titol, report);
  }

  Future<int> sendOrganizerApplication(
      String titol, String idActivitat, String motiu) async {
    return await controladorDomini.sendOrganizerApplication(
        titol, idActivitat, motiu);
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
        builder: (context) => MapPage(controladorPresentacion: this, vencidas: actividadesVencidas,),
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
            controladorPresentacion: this,
            username: usernameLogged,
            owner: true),
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
                user: _user,
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
  Future<String?> getPostId(String foroId, String data) async {
    return controladorDomini.getPostId(foroId, data);
  }

  //agafa id fe la reply
  Future<String?> getReplyId(String foroId, String? postId, String data) async {
    return controladorDomini.getReplyId(foroId, postId, data);
  }

  //afegir post a la bd
  Future<void> addPost(
      String foroId, String mensaje, String fecha, int numeroLikes) {
    return controladorDomini.addPost(foroId, mensaje, fecha, numeroLikes);
  }

  //afegir reply a la bd
  Future<void> addReplyPost(String foroId, String postId, String mensaje,
      String fecha, int numeroLikes) async {
    return controladorDomini.addReplyPost(
        foroId, postId, mensaje, fecha, numeroLikes);
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
  Future<void> deleteReply(
      String foroId, String? postId, String? replyId) async {
    return controladorDomini.deleteReply(foroId, postId, replyId);
  }

  //a partir de aqui modificar las que necesiten token o no

  Future<void> getXat(String receiverName) async {
    try {
      xatAmic? xat = await controladorDomini.xatExists(receiverName);

      if (xat != null) {
        // El foro existe, imprimir sus detalles
        print('Xat existente: $xat');
      } else {
        // El foro no existe, crear uno nuevo
        bool creadoExitosamente =
            await controladorDomini.createXat(receiverName);
        if (creadoExitosamente) {
          print('Nuevo xat creado');
        } else {
          throw Exception('Error al crear el xat');
        }
      }
    } catch (error) {
      throw Exception('Error al obtener o crear el xat: $error');
    }
  }

  Future<String> lastMsg(String receiverId) async {
    xatAmic? xat = await controladorDomini.xatExists(receiverId);
    return xat!.lastMessage;
  }

  Future<String> lasTime(String receiverId) async {
    xatAmic? xat = await controladorDomini.xatExists(receiverId);
    return xat!.timeLastMessage;
  }

  Future<void> addXatMessage(
      String senderId, String receiverId, String time, String text) async {
    String? xatId = await controladorDomini.getXatId(receiverId, senderId);
    controladorDomini.addMessage(xatId, time, text);
  }

  Future<List<Message>> getXatMessages(String sender, String receiver) async {
    String? xatId = await controladorDomini.getXatId(receiver, sender);
    List<Message> missatges = await controladorDomini.getMessages(xatId);
    return missatges;
  }

  Future<List<Grup>> getUserGrups() async {
    List<Grup> grups = await controladorDomini.getUserGrups();
    return grups;
  }

  void createGrup(
      String name, String description, String image, List<String> members) {
    controladorDomini.createGrup(name, description, image, members);
  }

  Future<Grup> getInfoGrup(String grupId) async {
    Grup info = await controladorDomini.getInfoGrup(grupId);
    return info;
  }

  void updateGrup(String grupId, String name, String description, String image,
      List<dynamic> members) {
    //es necesari afegir el meu user al llistat de membres?
    controladorDomini.updateGrup(grupId, name, description, image, members);
  }

  //el grupId esta afegit com a parametre dels grups
  void addGrupMessage(String grupId, String time, String text) async {
    try {
      controladorDomini.addGrupMessage(grupId, time, text);
    } catch (error) {
      throw Exception('Error al añadir mensaje al xat: $error');
    }
  }

  Future<List<Message>> getGrupMessages(String grupId) async {
    try {
      List<Message> missatges = await controladorDomini.getGrupMessages(grupId);
      return missatges;
    } catch (error) {
      throw Exception('Error al cojer mensajes del xat: $error');
    }
  }

  void mostrarFollows(BuildContext context, bool follows) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LlistarFollows(
          username: usernameLogged,
          controladorPresentacion: this,
          follows: follows,
        ),
      ),
    );
  }

  void mostrarPendents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LlistarPendents(
          username: usernameLogged,
          controladorPresentacion: this,
        ),
      ),
    );
  }

  void mostrarReportBug(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(controladorPresentacion: this),
      ),
    );
  }

  void mostrarSolicitutOrganitzador(
      BuildContext context, String titol, String idActivitat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolicitutScreen(
          controladorPresentacion: this,
          idActivitat: idActivitat,
          titolActivitat: titol,
        ),
      ),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      _language = Locale(languageCode);
    }
  }

  void changeLanguage(Locale? lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', lang!.languageCode);
    _loadLanguage();
  }

  /*Future<List<String>> obteAmics() async {
    return await controladorDomini.obteFollows(usernameLogged);
  }*/
}
