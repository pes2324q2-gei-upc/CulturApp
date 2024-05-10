import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:culturapp/presentacio/widgets/post_widget.dart';
import 'package:culturapp/presentacio/widgets/reply_widget.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VistaVerActividad extends StatefulWidget{

  final List<String> info_actividad;
  final ControladorPresentacion controladorPresentacion;
  final Uri uri_actividad;

  const VistaVerActividad({super.key, required this.info_actividad, required this.uri_actividad, required this.controladorPresentacion});

  @override
  State<VistaVerActividad> createState() => _VistaVerActividadState(controladorPresentacion ,info_actividad, uri_actividad);
}

class _VistaVerActividadState extends State<VistaVerActividad> {
  late ControladorPresentacion _controladorPresentacion; 
  late ControladorDomini controladorDominio;
  int _selectedIndex = 0;

  late List<String> infoActividad;
  late Uri uriActividad;


  bool mostrarDescripcionCompleta = false;
  
  bool estaApuntado = false;
  
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<List<Post>>? posts;
  Future<List<Post>>? replies;
  String idForo = "";
  String idPost = "";
  String? postIden = '';
  bool reply = false;
  bool mostraReplies = false;
  bool organizador = false;
  
  final List<String> catsAMB = ["Residus",
  "territori.espai_public_platges",
  "Sostenibilitat",
  "Aigua",
  "territori.espai_public_parcs",
  "Espai públic - Rius",
  "Espai públic - Parcs",
  "Portal de transparència",
  "Mobilitat sostenible",
  "Internacional",
  "Activitat econòmica",
  "Polítiques socials",
  "territori.espai_public_rius",
  "Espai públic - Platges"];
  
  _VistaVerActividadState(ControladorPresentacion controladorPresentacion ,List<String> info_actividad, Uri uri_actividad) {
    infoActividad = info_actividad;
    uriActividad = uri_actividad;
    _controladorPresentacion = controladorPresentacion;
    controladorDominio = _controladorPresentacion.getControladorDomini();
  }

  @override
  void initState(){
    super.initState();
    checkApuntado(_user!.uid, infoActividad);
  } 

    void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  
    switch (index) {
      case 0:
        _controladorPresentacion.mostrarMapa(context);
        break;
      case 1:
          _controladorPresentacion.mostrarActividadesUser(context);
        break;
      case 2:
        _controladorPresentacion.mostrarXats(context);
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
    _controladorPresentacion.getForo(infoActividad[1]); //verificar que tenga un foro
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("Activity".tr(context)),
        centerTitle: true, // Centrar el título
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Enviar solicitud de organizador') {
                _controladorPresentacion.mostrarSolicitutOrganitzador(context, infoActividad[0], infoActividad[1]);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Enviar solicitud de organizador',
                child: Text('Enviar solicitud de organizador'),
              ),
              if (!organizador)
                const PopupMenuItem<String>(
                  value: 'scan_qr',
                  child: Text('Escanear QR'),
                ),
              if (organizador)
                const PopupMenuItem<String>(
                  value: 'view_qr',
                  child: Text('Ver QR'),
                ),
            ],
          ),
        ],
      ),
       bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Column(
        children:[ 
          Expanded(
            child: ListView(
              children: [
                _imagenActividad(infoActividad[3]), //Accedemos imagenUrl
                _tituloBoton(infoActividad[0], infoActividad[2]), //Accedemos al nombre de la actividad y su categoria
                const SizedBox(height: 10),
                _descripcioActividad(infoActividad[4]), //Accedemos su descripcion
                _expansionDescripcion(),
                _infoActividad(infoActividad[7], infoActividad[5], infoActividad[6], infoActividad[2], uriActividad),
                _foro(),
              ], //Accedemos ubicación, dataIni, DataFi, uri actividad
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            //barra para añadir mensajes
            child: reply == false
              ? PostWidget(
                addPost: (foroId, mensaje, fecha, numeroLikes) async {
                  await _controladorPresentacion.addPost(foroId, mensaje, fecha, numeroLikes);

                  // Actualitza el llistat de posts
                  setState(() {
                    posts = _controladorPresentacion.getPostsForo(idForo);
                  });
                },
                activitat: infoActividad[1],
                controladorPresentacion: _controladorPresentacion,
              )
              : ReplyWidget(
                addReply: (foroId, postIden, mensaje, fecha, numeroLikes) async {
                  await _controladorPresentacion.addReplyPost(foroId, postIden, mensaje, fecha, numeroLikes);

                  // Actualitza el llistat de replies
                  setState(() {
                    replies = _controladorPresentacion.getReplyPosts(idForo, postIden);
                    reply = false;
                  });
                },
                foroId: idForo,
                postId: postIden,
              )
          ),
        ],  
      ),
    );
  }


  Widget _imagenActividad(String imagenUrl){
    return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imagenUrl,
                height: 200,
                width: double.infinity, 
                fit: BoxFit.cover, 
              ),
            ),
    );
  }

  Widget _tituloBoton(String tituloActividad, String categoriaActividad){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child:  Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _retornaIcon(categoriaActividad), 
          ),
          Expanded(
            child: Text(
              tituloActividad,
              style: const TextStyle(color: Color(0xFFF4692A), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {
              setState(() {
                manageSignupButton(infoActividad);
              });
            },
            style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
            estaApuntado ? Colors.black : const Color(0xFFF4692A),),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),),
            child: Text(estaApuntado ? 'signout'.tr(context) : 'signin'.tr(context)),
          ),
        ],
      )
    );
  }

  Widget _descripcioActividad(String descripcionActividad){
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            descripcionActividad,
            style: const TextStyle(fontSize: 16, ),
            maxLines: mostrarDescripcionCompleta ? null : 2,
            overflow: mostrarDescripcionCompleta ? null: TextOverflow.ellipsis,
            textAlign: TextAlign.justify, 
        ),
      );
  }
  
  Widget _expansionDescripcion() {
    return GestureDetector(
      onTap: () {
        setState(() {
          mostrarDescripcionCompleta = !mostrarDescripcionCompleta;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          mostrarDescripcionCompleta ? 'see_less'.tr(context) : 'see_more'.tr(context),
          style: const TextStyle(color: Colors.grey,),
        ),
      ),
    );
  }
  
  Widget _infoActividad(String ubicacion, String dataIni, String dataFi, String categorias, Uri urlEntrades) {
    return Container(
      color: Colors.grey.shade200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column( 
          children: [
          _getIconPlusTexto('ubicacion', ubicacion),
          _getIconPlusTexto('calendario', 'DataIni: $dataIni'),
          _getIconPlusTexto('calendario', 'DataFi: $dataFi'),
          Row(
            children: [
              const Icon(Icons.local_atm),
              const Padding(padding: EdgeInsets.only(right: 7.5)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    launchUrl(urlEntrades); 
                  },
                  child: const Text(
                    'Informació Entrades',
                    style: TextStyle(
                      decoration: TextDecoration.underline, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _getIconPlusTexto('categoria', categorias)
          ]
        ),
      ),
    );
  } 

 Widget _getIconPlusTexto(String categoria, String texto){

    late Icon icono; 

    switch(categoria){
      case 'ubicacion':
        icono = const Icon(Icons.location_on);
        break;
      case 'calendario':
        icono = const Icon(Icons.calendar_month);
        break;
      case 'categoria':
        icono = const Icon(Icons.category);

        List<String> listaCategoriasMayusculas = (texto.split(', ')).map((categoria) {
          return '${categoria[0].toUpperCase()}${categoria.substring(1)}';
        }).toList();

        texto = listaCategoriasMayusculas.join(', ');
        
        break;
    }

    return  Row(
      children: [
        icono,
        const Padding(padding: EdgeInsets.only(right: 7.5)),
        Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  //Posible duplicaciñon de código
  Image _retornaIcon(String categoria) {
    if (catsAMB.contains(categoria)){
      return Image.asset(
            'assets/categoriareciclar.png',
            width: 45.0,
          );
    }
    else {
      switch (categoria) {
        case 'carnavals':
          return Image.asset(
            'assets/categoriacarnaval.png',
            width: 45.0,
          );
        case 'teatre':
          return Image.asset(
            'assets/categoriateatre.png',
            width: 45.0,
          );
        case 'concerts':
          return Image.asset(
            'assets/categoriaconcert.png',
            width: 45.0,
          );
        case 'circ':
          return Image.asset(
            'assets/categoriacirc.png',
            width: 45.0,
          );
        case 'exposicions':
          return Image.asset(
            'assets/categoriaarte.png',
            width: 45.0,
          );
        case 'conferencies':
          return Image.asset(
            'assets/categoriaconfe.png',
            width: 45.0,
          );
        case 'commemoracions':
          return Image.asset(
            'assets/categoriacommemoracio.png',
            width: 45.0,
          );
        case 'rutes-i-visites':
          return Image.asset(
            'assets/categoriaruta.png',
            width: 45.0,
          );
        case 'cursos':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'activitats-virtuals':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'infantil':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'festes':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'festivals-i-mostres':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'dansa':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'cicles':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'cultura-digital':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'fires-i-mercats':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'gegants':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        default:
          return Image.asset(
            'assets/categoriarecom.png',
            width: 45.0,
          );
      }
    }
  }

  void _showDeleteOption(BuildContext context, Post post, bool reply) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('erase_post'.tr(context)),
          content: Text('sure_erase'.tr(context)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el dialog
              },
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                if(!reply) {
                  String? postId = await _controladorPresentacion.getPostId(idForo, post.fecha);
                  _deletePost(post, postId);
                }
                else {
                  String? replyId = await _controladorPresentacion.getReplyId(idForo, postIden, post.fecha);
                  _deleteReply(post, postIden, replyId);
                }
                Navigator.of(context).pop(); // Cierra el dialog
              },
              child: Text('erase'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePost(Post post, String? postId) async{

    _controladorPresentacion.deletePost(idForo, postId);

    setState(() {
      posts = _controladorPresentacion.getPostsForo(idForo);
    });
  }

  Future<void> _deleteReply(Post reply, String? postId, String? replyId) async{

    _controladorPresentacion.deleteReply(idForo, postId, replyId);

    setState(() {
      replies = _controladorPresentacion.getReplyPosts(idForo, postId);
    });
  }

  //conseguir posts del foro
  Future<List<Post>> getPosts() async {
    String? foroId = await _controladorPresentacion.getForoId(infoActividad[1]);
    if (foroId != null) {
      idForo = foroId;
      List<Post> fetchedPosts = await _controladorPresentacion.getPostsForo(foroId);
      return fetchedPosts;
    }
    return[];
  }

  //conseguir replies del foro
  Future<List<Post>> getReplies(String data) async {
    String? postId = await _controladorPresentacion.getPostId(idForo, data);
    if (postId != null) {
      idPost = postId;
      List<Post> fetchedReply = await _controladorPresentacion.getReplyPosts(idForo, postId);
      return fetchedReply;
    }
    return [];
  }

  //funcion que lista todos los posts del foro de la actividad
  Widget _foro() {
    return FutureBuilder<List<Post>>(
      future: getPosts(), 
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(), 
                const SizedBox(height: 10), 
                Text('loading'.tr(context)),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Si hi ha hagut algun error
        } else {
          List<Post> posts = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Text(
                      //quereis que añada tambien el numero de replies?
                      'comments'.trWithArg(context, {"num": "${posts.length}"}),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  mostrarReplies(),
                ]
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  DateTime dateTime = DateTime.parse(post.fecha);
                  String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //se tendra que modificar por la imagen del usuario
                            const Icon(Icons.account_circle, size: 45), // Icono de usuario
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.username), // Nombre de usuario
                                const SizedBox(width: 5),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            //fer que nomes el que l'ha creat ho pugui veure
                            _buildPopUpMenuNotBlocked(context, post, false, post.username, ''),
                            /*
                            GestureDetector(
                              onTap: () async {
                                _showDeleteOption(context, post, false);
                              },
                              child: const Icon(Icons.more_vert, size: 20),
                            ),
                            */
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            post.mensaje, // Mensaje del post
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                            IconButton(
                              icon: Icon(
                                post.numeroLikes > 0 ? Icons.favorite : Icons.favorite_border, 
                                color: post.numeroLikes > 0 ? Colors.red : null, 
                              ),
                              onPressed: () {
                                setState(() {
                                  if (post.numeroLikes > 0) {
                                    post.numeroLikes = 0; // Si ya hay likes, los elimina
                                  } else {
                                    post.numeroLikes = 1; // Si no hay likes, añade uno
                                  }
                                });
                              },
                            ),
                              Text('me_gusta'.tr(context)),
                              const SizedBox(width: 20),
                              //respuesta
                              IconButton(
                                icon: const Icon(Icons.reply), // Icono de responder
                                onPressed: () async {
                                  postIden = await _controladorPresentacion.getPostId(idForo, post.fecha);
                                  setState(() {
                                     reply = true;
                                  });
                                },
                              ), 
                              const SizedBox(width: 5),
                              Text('reply'.tr(context)),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                        if (mostraReplies) 
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: infoReply(post.fecha)
                          )
                      ], 
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget infoReply(date) {
    return FutureBuilder<List<Post>>(
      future: getReplies(date), 
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mentres no acaba el future
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Si hi ha hagut algun error
        } else {
          List<Post> reps = snapshot.data!;
          return Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reps.length,
                itemBuilder: (context, index) {
                  final rep = reps[index];
                  DateTime dateTime = DateTime.parse(rep.fecha);
                  String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //se tendra que modificar por la imagen del usuario
                            const Icon(Icons.account_circle, size: 45), // Icono de usuario
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rep.username), // Nombre de usuario
                                const SizedBox(width: 5),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            //fer que nomes el que l'ha creat ho pugui veure
                            _buildPopUpMenuNotBlocked(context, rep, true, rep.username, date)
                            /*
                            GestureDetector(
                              onTap: () async {
                                postIden = await _controladorPresentacion.getPostId(idForo, date);
                                _showDeleteOption(context, rep, true);
                              },
                              child: const Icon(Icons.more_vert, size: 20),
                            ),
                            */
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            rep.mensaje, // Mensaje del post
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  rep.numeroLikes > 0 ? Icons.favorite : Icons.favorite_border, 
                                  color: rep.numeroLikes > 0 ? Colors.red : null, 
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (rep.numeroLikes > 0) {
                                      rep.numeroLikes = 0; 
                                    } else {
                                      rep.numeroLikes = 1; 
                                    }
                                  });
                                },
                              ),
                              Text('me_gusta'.tr(context))
                            ]
                          )
                        )
                      ]
                    )
                  );
                }
              )
            ]
          );
        }
      }
    );
  }

  Widget mostrarReplies(){
    return GestureDetector(
      onTap: () {
        setState(() {
          mostraReplies = !mostraReplies;
        });
      },
      child: Padding(        
        padding: const EdgeInsets.only(left: 180),
        child: Text(
          mostraReplies ? 'no_reply'.tr(context) : 'see_reply'.tr(context),
          style: const TextStyle(color: Colors.grey,),
        ),
      ),
    );
  }

  Widget _buildPopUpMenuNotBlocked(BuildContext context, Post post, bool reply, String username, String date) {
    String owner = _controladorPresentacion.getUsername();
    if(owner == username) {
      return _buildPopupMenu([
      'Bloquear usuario',
      'Reportar usuario',
      (reply) ? 'Eliminar reply' : 'Eliminar post',
    ], context, post, reply, username, date);
    } else {
      return _buildPopupMenu([
      'Bloquear usuario',
      'Reportar usuario',
    ], context, post, reply, username, date);
    }
  }

  Widget _buildPopUpMenuBloqued(BuildContext context, Post post, bool reply, String username, String date) {
    String owner = _controladorPresentacion.getUsername();
    if(owner == username) {
      return _buildPopupMenu([
      'Desbloquear usuario',
      'Reportar usuario',
      (reply) ? 'Eliminar reply' : 'Eliminar post',
    ], context, post, reply, username, date);
    } else {
      return _buildPopupMenu([
      'Desbloquear usuario',
      'Reportar usuario',
    ], context, post, reply, username, date);
    }
  }

  
  Future<bool?> confirmPopUp(String dialogContent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopupMenu(List<String> options, BuildContext context, Post post, bool reply, String username, String date) {
    return Row(
      children: [
        const SizedBox(width: 8.0),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          itemBuilder: (BuildContext context) => options.map((String option) {
            return PopupMenuItem(
              value: option,
              child:Text(option, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onSelected: (String value) async {
            switch(value) {
              case 'Bloquear usuario':
                final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres bloquear a $username?");
                if(confirm == true) {
                  //_controladorPresentacion.blockUser(username);
                }
                break;
              case 'Desbloquear usuario':
                final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres desbloquear a $username?");
                if(confirm == true) {
                  //_controladorPresentacion.reportUser(code, username);
                }
                break;
              case 'Reportar usuario':
                final bool? confirm = await confirmPopUp("¿Estás seguro de que quieres reportar a $username?");
                if(confirm == true) {
                  _controladorPresentacion.mostrarReportUser(context, username);
                }
                break;
              case 'Eliminar post':
                _showDeleteOption(context, post, reply);
                break;
              case 'Eliminar reply':
                postIden = await _controladorPresentacion.getPostId(idForo, date);
                _showDeleteOption(context, post, reply);
                break;
            }
          },
        ),
      ],
    );
  }

  void manageSignupButton(List<String> infoactividad) {
    if (mounted) {
      setState(() {
        if (estaApuntado) {
          controladorDominio.signoutFromActivity(_user?.uid, infoActividad[1]);
          estaApuntado = false;
        }
        else {
          controladorDominio.signupInActivity(_user?.uid, infoActividad[1]);
          estaApuntado = true;
        }
      });
    }
  }

  void checkApuntado(String uid, List<String> infoactividad) async {
    bool apuntado = await controladorDominio.isUserInActivity(uid, infoactividad[1]);
    if (mounted) {
      setState(() {
        estaApuntado = apuntado;
      });
    }
  }
  
}

