import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/post_widget.dart';
import 'package:culturapp/presentacio/widgets/reply_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//name, code, categoria, imageUrl, description, dataInici, dataFi, ubicacio
// urlEntrades


class VistaVerActividad extends StatefulWidget{

  final List<String> info_actividad;

  final Uri uri_actividad;

  const VistaVerActividad({super.key, required this.info_actividad, required this.uri_actividad});

  @override
  State<VistaVerActividad> createState() => _VistaVerActividadState(info_actividad, uri_actividad);
}

class _VistaVerActividadState extends State<VistaVerActividad> {

  final ControladorDomini controladorDominio = ControladorDomini();
  final ControladorPresentacion controladorPresentacion = ControladorPresentacion();

  late List<String> infoActividad;
  late Uri uriActividad;

  bool mostrarDescripcionCompleta = false;
  
  bool estaApuntado = false;
  
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<List<Post>>? posts;
  Future<List<Post>>? replies;
  String idForo = "";
  String idPost = "";
  bool reply = false;
  bool mostraReplies = false;
  String? postIden = '';
  
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
  

  _VistaVerActividadState(List<String> info_actividad, Uri uri_actividad) {
    infoActividad = info_actividad;
    uriActividad = uri_actividad;
  }

  @override
  void initState(){
    super.initState();
    checkApuntado(_user!.uid, infoActividad);
  } 

  @override
  Widget build(BuildContext context) {
    controladorPresentacion.getForo(infoActividad[1]); //verificar que tenga un foro
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Actividad"),
        centerTitle: true, // Centrar el título
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
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
                _infoActividad(infoActividad[7], infoActividad[5], infoActividad[6], uriActividad),
                _foro(),
              ], //Accedemos ubicación, dataIni, DataFi, uri actividad
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            //barra para añadir mensajes
            child: reply == false
              ? PostWidget(
                addPost: (foroId, username, mensaje, fecha, numeroLikes) async {
                  await controladorDominio.addPost(foroId, username, mensaje, fecha, numeroLikes);

                  // Actualitza el llistat de posts
                  setState(() {
                    posts = controladorDominio.getPostsForo(idForo);
                  });
                },
                foroId: idForo,
              )
              : ReplyWidget(
                addReply: (foroId, postIden, username, mensaje, fecha, numeroLikes) async {
                  await controladorDominio.addReplyPost(foroId, postIden, username, mensaje, fecha, numeroLikes);

                  // Actualitza el llistat de posts
                  setState(() {
                    replies = controladorDominio.getReplyPosts(idForo, postIden);
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
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Establece márgenes horizontales
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imagenUrl,
                height: 200,
                width: double.infinity, //Ocupar todo espacio posible horizontal
                fit: BoxFit.cover, //Escala y recorta imagen para que ocupe todo el cuadro, manteniendo proporcion aspecto
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
            child: _retornaIcon(categoriaActividad), //Obtener el icono de la categoria
          ),
          Expanded(
            child: Text(
              tituloActividad,
              style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
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
            estaApuntado ? Colors.black : Colors.orange,),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),),
            child: Text(estaApuntado ? 'Desapuntarse' : 'Apuntarse'),
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
            textAlign: TextAlign.justify, //hacer que el texto se vea formato cuadrado
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
          mostrarDescripcionCompleta ? "Ver menos" : "Ver más",
          style: const TextStyle(color: Colors.grey,),
        ),
      ),
    );
  }
  
  Widget _infoActividad(String ubicacion, String dataIni, String dataFi, Uri urlEntrades) {
    return Container(
      color: Colors.grey.shade200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column( 
          children: [
          _getIconPlusTexto('ubicacion', ubicacion),
          _getIconPlusTexto('calendario', dataIni),
          _getIconPlusTexto('calendario', dataFi),
          Row(
            children: [
              const Icon(Icons.local_atm),
              const Padding(padding: EdgeInsets.only(right: 7.5)),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    launchUrl(urlEntrades); // Abrir la url de la actividad para ir a su pagina
                  },
                  child: const Text(
                    'Informació Entrades',
                    style: TextStyle(
                      decoration: TextDecoration.underline, // Subrayar 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ]
        ),
      ),
    );
  } 

 Widget _getIconPlusTexto(String categoria, String texto){

    late Icon icono; //late para indicar que se inicializará en el futuro y que cuando se acceda a su valor no sea nulo

    switch(categoria){
      case 'ubicacion':
        icono = const Icon(Icons.location_on);
        break;
      case 'calendario':
        icono = const Icon(Icons.calendar_month);
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

  //conseguir posts del foro
  Future<List<Post>> getPosts() async {
    String? foroId = await controladorPresentacion.getForoId(infoActividad[1]);
    if (foroId != null) {
      idForo = foroId;
      List<Post> fetchedPosts = await controladorDominio.getPostsForo(foroId);
      return fetchedPosts;
    }
    return[];
  }

  void _showDeleteOption(BuildContext context, Post post, bool reply) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Post'),
          content: const Text('Estas segur de que vols eliminar aquest post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el dialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if(!reply) {
                  String? postId = await controladorPresentacion.getPostId(idForo, post.fecha);
                  _deletePost(post, postId);
                }
                else {
                  print(post.fecha);
                  String? replyId = await controladorPresentacion.getReplyId(idForo, postIden, post.fecha);
                  print(replyId);
                  _deleteReply(post, postIden, replyId);
                }
                Navigator.of(context).pop(); // Cierra el dialog
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  //fer que nomes el pugui eliminar el que l'ha creat
  void _deletePost(Post post, String? postId) async {

    await controladorDominio.deletePost(idForo, postId);
    
    //actualitza el llistat de posts
    setState(() {
      posts = controladorDominio.getPostsForo(idForo);
    });
  }

  void _deleteReply(Post reply, String? postId, String? replyId) async {

    await controladorDominio.deleteReply(idForo, postId, replyId);

    setState(() {
      replies = controladorDominio.getReplyPosts(idForo, postId);
    });
  }

  //conseguir replies del foro
  Future<List<Post>> getReplies(String data) async {
    //print("entra a getReplies");
    String? postId = await controladorPresentacion.getPostId(idForo, data);
    if (postId != null) {
      //print("id del post: $postId");
      idPost = postId;
      List<Post> fetchedReply = await controladorDominio.getReplyPosts(idForo, postId);
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
          return const CircularProgressIndicator(); // Mentres no acaba el future
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
                      '${posts.length} comentarios',
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
                            GestureDetector(
                              onTap: () async {
                                _showDeleteOption(context, post, false);
                              },
                              child: const Icon(Icons.more_vert, size: 20),
                            ),
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
                                post.numeroLikes > 0 ? Icons.favorite : Icons.favorite_border, // Cambia el icono según si hay likes o no
                                color: post.numeroLikes > 0 ? Colors.red : null, // Cambia el color si hay likes
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
                              //si queremos que salga un contador de me gustas
                              //Text(post.likes.toString()),
                              const Text('Me gusta'),
                              const SizedBox(width: 20),
                              //hacer que te permita escribir un nuevo mensaje
                              IconButton(
                                icon: const Icon(Icons.reply), // Icono de responder
                                onPressed: () async {
                                  postIden = await controladorPresentacion.getPostId(idForo, post.fecha);
                                  setState(() {
                                     reply = true;
                                  });
                                },
                              ), 
                              const SizedBox(width: 5),
                              const Text('Responder'),
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
                            GestureDetector(
                              onTap: () async {
                                postIden = await controladorPresentacion.getPostId(idForo, date);
                                _showDeleteOption(context, rep, true);
                              },
                              child: const Icon(Icons.more_vert, size: 20),
                            ),
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
                                  rep.numeroLikes > 0 ? Icons.favorite : Icons.favorite_border, // Cambia el icono según si hay likes o no
                                  color: rep.numeroLikes > 0 ? Colors.red : null, // Cambia el color si hay likes
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (rep.numeroLikes > 0) {
                                      rep.numeroLikes = 0; // Si ya hay likes, los elimina
                                    } else {
                                      rep.numeroLikes = 1; // Si no hay likes, añade uno
                                    }
                                  });
                                },
                              ),
                              //si queremos que salga un contador de me gustas
                              //Text(post.likes.toString()),
                              const Text('Me gusta')
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
          mostraReplies ? "Esconder replies" : "Ver replies",
          style: const TextStyle(color: Colors.grey,),
        ),
      ),
    );
  }

  void manageSignupButton(List<String> infoactividad) {
    if (mounted) {
      setState(() {
        if (estaApuntado) {
          //print("entrado en el true");
          controladorDominio.signoutFromActivity(_user?.uid, infoActividad[1]);
          estaApuntado = false;
        }
        else {
          //print("entrado en el false");
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

