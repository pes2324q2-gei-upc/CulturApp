import 'dart:math';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:culturapp/domain/converters/notificacions.dart';
import 'package:culturapp/domain/models/bateria.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:culturapp/presentacio/widgets/post_widget.dart';
import 'package:culturapp/presentacio/widgets/reply_widget.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/bateria_box.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class VistaVerActividad extends StatefulWidget {
  final List<String> info_actividad;
  final ControladorPresentacion controladorPresentacion;
  final Uri uri_actividad;
  final bool esOrganizador;
  final List<Bateria> bateriasDisp;

  const VistaVerActividad(
      {super.key,
      required this.info_actividad,
      required this.uri_actividad,
      required this.controladorPresentacion,
      required this.esOrganizador,
      required this.bateriasDisp});

  @override
  State<VistaVerActividad> createState() => _VistaVerActividadState(
      controladorPresentacion,
      info_actividad,
      uri_actividad,
      esOrganizador,
      bateriasDisp);
}

class _VistaVerActividadState extends State<VistaVerActividad> {
  late ControladorPresentacion _controladorPresentacion;
  late ControladorDomini controladorDominio;
  int _selectedIndex = 0;

  late List<String> infoActividad;
  late Uri uriActividad;
  final _formKey = GlobalKey<FormState>();
  final _codeControler = TextEditingController();

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
  bool organizador = true;
  List<Bateria> bateriasCerca = [];
  Bateria bat = Bateria();
  Bateria bat1 = Bateria();
  Bateria bat2 = Bateria();
  List<Bateria> bateriasDisponibles = [];
  bool _isLoading = false;

  final List<String> catsAMB = [
    "Residus",
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
    "Espai públic - Platges"
  ];

  bool _editMode = false; // Variable de estado para controlar el modo de edición
  String _editableText = "Texto por defecto";

  _VistaVerActividadState(
      ControladorPresentacion controladorPresentacion,
      List<String> info_actividad,
      Uri uri_actividad,
      bool esOrganizador,
      List<Bateria> bats) {
    infoActividad = info_actividad;
    uriActividad = uri_actividad;
    _controladorPresentacion = controladorPresentacion;
    controladorDominio = _controladorPresentacion.getControladorDomini();
    organizador = esOrganizador;
    bateriasDisponibles = bats;
  }

  void mostrarQR() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              BarcodeWidget(
                padding: const EdgeInsets.only(left: 15, right: 15),
                barcode: Barcode.qrCode(),
                data: infoActividad[1],
                width: 250,
                height: 250,
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Text(
                'Code: ${infoActividad[1]}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
            ],
          ),
        );
      },
    );
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  void mostrarEscaneoQR() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.625,
            height: MediaQuery.of(context).size.height * 0.55,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const Text(
                    'Participa en la actividad y obten recompensas exclusivas!',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon:
                        const Icon(Icons.qr_code_scanner, color: Colors.white),
                    label: const Text('Escanear QR'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    onPressed: () async {
                      await requestCameraPermission();
                      ScanResult qrResult = await BarcodeScanner.scan();
                      String qrResultString = qrResult.rawContent;
                      if (qrResultString.toString() == infoActividad[1]) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Gracias por participar!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _controladorPresentacion
                            .addParticipant(infoActividad[1]);
                        setState(() {
                          estaApuntado = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'QR no escaneado o no coincidente con la actividad.',
                              textAlign: TextAlign.justify,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'También puedes introducir el código de la actividad manualmente:',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _codeControler,
                      minLines: 1,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Introduce el código",
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Por favor, introduce un código'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          _participar();
                        }
                      },
                      child: Text("send".tr(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _participar() {
    if (_codeControler.text == infoActividad[1]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Gracias por participar!'),
          backgroundColor: Colors.green,
        ),
      );
      _controladorPresentacion.addParticipant(infoActividad[1]);
      setState(() {
        estaApuntado = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El código no es coincidente con la actividad.',
            textAlign: TextAlign.justify,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> calculaBateriasCercanas() async {
    double latitud = double.parse(infoActividad[8]);
    double longitud = double.parse(infoActividad[9]);

    List<Bateria> bateriasCercanas = [];

    for (var bateria in bateriasDisponibles) {
      double distancia = calcularDistancia(
          latitud, longitud, bateria.latitud, bateria.longitud);
      if (distancia <= 5) {
        bateria.distancia = distancia;
        bateriasCercanas.add(bateria);
      }
    }
    bateriasCerca = bateriasCercanas;
  }

  @override
  void initState() {
    super.initState();
    checkApuntado(_user!.uid, infoActividad);
    calculaBateriasCercanas();
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
        _controladorPresentacion.mostrarXats(context, "Amics");
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  bool isStreetAddress(String address) {
    final regex = RegExp(r'[a-zA-Z]+\s+\d');
    return regex.hasMatch(address);
  }

  void mostrarBaterias() {
    bateriasCerca.sort((a, b) {
    return a.distancia.compareTo(b.distancia);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Image.asset(
                            'assets/categoriabateria.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                        ),
                        const SizedBox(width: 10.0), 
                        const Text(
                          'Carregadors propers:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...bateriasCerca.where((bateria) => isStreetAddress(bateria.address)).map((bateria) => Padding(
                    padding: const EdgeInsets.only(bottom: 5.0,), // Agrega un espacio en la parte inferior
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de la pantalla
                      child: bateriaBox(
                        adress: bateria.address,
                        kw: bateria.kw, 
                        speed: bateria.speed, 
                        distancia: bateria.distancia, 
                        latitud: bateria.latitud, 
                        longitud: bateria.longitud
                      ),
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _controladorPresentacion
        .getForo(infoActividad[1]); //verificar que tenga un foro
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: const Color(0xFFF4692A),
            backgroundColor: Colors.white,
          ))
        : Scaffold(
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
                color:
                    Colors.white, // Cambia el color de la flecha de retroceso
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'Enviar solicitud de organizador') {
                      _controladorPresentacion.mostrarSolicitutOrganitzador(
                          context, infoActividad[0], infoActividad[1]);
                    } else if (result == 'share_act') {
                      if (infoActividad[5] == infoActividad[6] &&
                          infoActividad[7] != 'No disponible') {
                        Share.share(
                          ' ¡No te pierdas esta increíble actividad cultural que acabo de encontrar en CulturApp!\n\n Descubre ${infoActividad[0]} el dia ${infoActividad[5]} en ${infoActividad[7]}.\n\n ¡Nos vemos ahi! 🎉🎉🎉\n\n ',
                          subject: 'Actividad cultural: ${infoActividad[0]}',
                        );
                      } else if (infoActividad[5] != infoActividad[6] &&
                          infoActividad[7] != 'No disponible') {
                        Share.share(
                          ' ¡No te pierdas esta increíble actividad cultural que acabo de encontrar en CulturApp!\n\n Descubre ${infoActividad[0]} del dia ${infoActividad[5]} hasta el dia ${infoActividad[6]} en ${infoActividad[7]}.\n\n ¡Nos vemos ahi! 🎉🎉🎉\n\n ',
                          subject: 'Actividad cultural: ${infoActividad[0]}',
                        );
                      } else if (infoActividad[5] != infoActividad[6] &&
                          infoActividad[7] == 'No disponible') {
                        Share.share(
                          ' ¡No te pierdas esta increíble actividad cultural que acabo de encontrar en CulturApp!\n\n Descubre ${infoActividad[0]} del dia ${infoActividad[5]} hasta el dia ${infoActividad[6]}.\n\n ¡Nos vemos ahi! 🎉🎉🎉\n\n ',
                          subject: 'Actividad cultural: ${infoActividad[0]}',
                        );
                      } else if (infoActividad[5] == infoActividad[6] &&
                          infoActividad[7] == 'No disponible') {
                        Share.share(
                          ' ¡No te pierdas esta increíble actividad cultural que acabo de encontrar en CulturApp!\n\n Descubre ${infoActividad[0]} el dia ${infoActividad[5]}.\n\n ¡Nos vemos ahi! 🎉🎉🎉\n\n ',
                          subject: 'Actividad cultural: ${infoActividad[0]}',
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Enviar solicitud de organizador',
                      child: Text('Enviar solicitud de organizador'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'share_act',
                      child: Text('Compartir'),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _imagenActividad(infoActividad[3]), //Accedemos imagenUrl
                      _tituloBoton(
                          infoActividad[0],
                          infoActividad[
                              2]), //Accedemos al nombre de la actividad y su categoria
                      const SizedBox(height: 10),
                      _descripcioActividad(
                          infoActividad[4]), //Accedemos su descripcion
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFF4692A),
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recompensa:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              FutureBuilder<String?>(
                                future: _controladorPresentacion.getRecompensa(infoActividad[1]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                      "Error",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    );
                                  } else if (snapshot.hasData && snapshot.data != null) {
                                    return Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      "No disponible",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                },
                              ),
                              if (organizador)
                                Row(
                                  children: [
                                    _editMode
                                        ? SizedBox(
                                            width: 100,
                                            child: TextField(
                                              onSubmitted: (value) {
                                                _actualizarRecompensa(value);
                                              },
                                              controller: TextEditingController()..text = _editableText,
                                              decoration: const InputDecoration(
                                                hintText: "Edita el texto",
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _editableText,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF333333),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _editMode = !_editMode;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _expansionDescripcion(),
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      _infoActividad(infoActividad[7], infoActividad[5],
                          infoActividad[6], infoActividad[2], uriActividad),
                      _foro(),
                    ], //Accedemos ubicación, dataIni, DataFi, uri actividad
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    //barra para añadir mensajes
                    child: reply == false
                        ? PostWidget(
                            addPost:
                                (foroId, mensaje, fecha, numeroLikes) async {
                              await _controladorPresentacion.addPost(
                                  foroId, mensaje, fecha, numeroLikes);

                              // Actualitza el llistat de posts
                              setState(() {
                                posts = _controladorPresentacion
                                    .getPostsForo(idForo);
                              });
                            },
                            activitat: infoActividad[1],
                            controladorPresentacion: _controladorPresentacion,
                          )
                        : ReplyWidget(
                            addReply: (foroId, postIden, mensaje, fecha,
                                numeroLikes) async {
                              await _controladorPresentacion.addReplyPost(
                                  foroId,
                                  postIden,
                                  mensaje,
                                  fecha,
                                  numeroLikes);

                              // Actualitza el llistat de replies
                              setState(() {
                                replies = _controladorPresentacion
                                    .getReplyPosts(idForo, postIden);
                                reply = false;
                              });
                            },
                            foroId: idForo,
                            postId: postIden,
                          )),
              ],
            ),
          );
  }

  Widget _imagenActividad(String imagenUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imagenUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 32.5, // Establece la altura del botón
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.black, // Color del texto y del icono
                  ),
                  icon: const Icon(Icons.location_on),
                  label: const Text('Como llegar'),
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${infoActividad[8]},${infoActividad[9]}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'No se pudo abrir $url';
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _actualizarRecompensa(String nuevaRecompensa) async {
    try {
      await _controladorPresentacion.actualizarRecompensa(infoActividad[1], nuevaRecompensa);
      setState(() {
        _editableText = nuevaRecompensa;
        _editMode = false;
      });
    } catch (error) {
      print('Error al actualizar la recompensa: $error');
    }
  }

  Widget _tituloBoton(String tituloActividad, String categoriaActividad) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _retornaIcon(categoriaActividad.split(',')[0]),
            ),
            Expanded(
              child: Text(
                tituloActividad,
                style: const TextStyle(
                    color: Color(0xFFF4692A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
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
                  estaApuntado ? Colors.black : const Color(0xFFF4692A),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                  estaApuntado ? 'signout'.tr(context) : 'signin'.tr(context)),
            ),
          ],
        ));
  }

  Widget _descripcioActividad(String descripcionActividad) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        descripcionActividad,
        style: const TextStyle(
          fontSize: 14,
        ),
        maxLines: mostrarDescripcionCompleta ? null : 4,
        overflow: mostrarDescripcionCompleta ? null : TextOverflow.ellipsis,
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
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          mostrarDescripcionCompleta
              ? 'see_less'.tr(context)
              : 'see_more'.tr(context),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _infoActividad(String ubicacion, String dataIni, String dataFi,
      String categorias, Uri urlEntrades) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 5)),
          _getIconPlusTexto('ubicacion', ubicacion),
          _getIconPlusTexto('calendario', '$dataIni'),
          if (dataIni != dataFi) _getIconPlusTexto('calendario', '$dataFi'),
          _getIconPlusTexto('categoria', categorias),
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
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 2)),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color(0xFFF4692A), // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5)), // Forma del botón
                      ),
                      onPressed: () {
                        mostrarBaterias();
                      },
                      child: const FittedBox(
                        child: Row(
                          children: [
                            Icon(Icons.battery_charging_full,
                                color: Colors.white), // Icono de un rayo
                            Text('Ver cargadores cercanos'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        if (organizador) {
                          mostrarQR();
                        } else {
                          mostrarEscaneoQR();
                        }
                      },
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(organizador
                                ? 'Mostrar QR'
                                : 'Participar en la actividad'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 7.5)),
        ]),
      ),
    );
  }

  Widget _getIconPlusTexto(String categoria, String texto) {
    late Icon icono;

    switch (categoria) {
      case 'ubicacion':
        icono = const Icon(Icons.location_on);
        break;
      case 'calendario':
        icono = const Icon(Icons.calendar_month);
        break;
      case 'categoria':
        icono = const Icon(Icons.category);

        List<String> listaCategoriasMayusculas =
            (texto.split(', ')).map((categoria) {
          return '${categoria[0].toUpperCase()}${categoria.substring(1)}';
        }).toList();
        texto = listaCategoriasMayusculas.join(', ');
        break;
    }

    return Row(
      children: [
        icono,
        const Padding(padding: EdgeInsets.only(right: 7.5)),
        Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  //Posible duplicaciñon de código
  Image _retornaIcon(String categoria) {
    if (catsAMB.contains(categoria)) {
      return Image.asset(
        'assets/categoriareciclar.png',
        width: 45.0,
      );
    } else {
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
                if (!reply) {
                  String? postId = await _controladorPresentacion.getPostId(
                      idForo, post.fecha);
                  _deletePost(post, postId);
                } else {
                  String? replyId = await _controladorPresentacion.getReplyId(
                      idForo, postIden, post.fecha);
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

  Future<void> _deletePost(Post post, String? postId) async {
    _controladorPresentacion.deletePost(idForo, postId);

    setState(() {
      posts = _controladorPresentacion.getPostsForo(idForo);
    });
  }

  Future<void> _deleteReply(Post reply, String? postId, String? replyId) async {
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
      List<Post> fetchedPosts =
          await _controladorPresentacion.getPostsForo(foroId);
      return fetchedPosts;
    }
    return [];
  }

  //conseguir replies del foro
  Future<List<Post>> getReplies(String data) async {
    String? postId = await _controladorPresentacion.getPostId(idForo, data);
    if (postId != null) {
      idPost = postId;
      List<Post> fetchedReply =
          await _controladorPresentacion.getReplyPosts(idForo, postId);
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
              Row(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    //quereis que añada tambien el numero de replies?
                    'comments'.trWithArg(context, {"num": "${posts.length}"}),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                mostrarReplies(),
              ]),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  DateTime dateTime = DateTime.parse(post.fecha);
                  String formattedDate =
                      DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //se tendra que modificar por la imagen del usuario
                            const Icon(Icons.account_circle,
                                size: 45), // Icono de usuario
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
                            _buildPopUpMenuNotBlocked(
                                context, post, false, post.username, ''),
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
                                  post.numeroLikes > 0
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      post.numeroLikes > 0 ? Colors.red : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (post.numeroLikes > 0) {
                                      post.numeroLikes =
                                          0; // Si ya hay likes, los elimina
                                    } else {
                                      post.numeroLikes =
                                          1; // Si no hay likes, añade uno
                                    }
                                  });
                                },
                              ),
                              Text('me_gusta'.tr(context)),
                              const SizedBox(width: 20),
                              //respuesta
                              IconButton(
                                icon: const Icon(
                                    Icons.reply), // Icono de responder
                                onPressed: () async {
                                  postIden = await _controladorPresentacion
                                      .getPostId(idForo, post.fecha);
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
                              child: infoReply(post.fecha))
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
            return Text(
                'Error: ${snapshot.error}'); // Si hi ha hagut algun error
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
                        String formattedDate =
                            DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
                        return ListTile(
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                children: [
                                  //se tendra que modificar por la imagen del usuario
                                  const Icon(Icons.account_circle,
                                      size: 45), // Icono de usuario
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(rep.username), // Nombre de usuario
                                      const SizedBox(width: 5),
                                      Text(
                                        formattedDate,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  //fer que nomes el que l'ha creat ho pugui veure
                                  _buildPopUpMenuNotBlocked(
                                      context, rep, true, rep.username, date)
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
                                  child: Row(children: [
                                    IconButton(
                                      icon: Icon(
                                        rep.numeroLikes > 0
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: rep.numeroLikes > 0
                                            ? Colors.red
                                            : null,
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
                                  ]))
                            ]));
                      })
                ]);
          }
        });
  }

  Widget mostrarReplies() {
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
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPopUpMenuNotBlocked(
      BuildContext context, Post post, bool reply, String owner, String date) {
    String userLogged = _controladorPresentacion.getUsername();
    if (owner == userLogged) {
      return _buildPopupMenu([
        (reply) ? "delete_reply".tr(context) : "delete_post".tr(context),
      ], context, post, reply, owner, date);
    } else {
      return _buildPopupMenu([
        "block_user".tr(context),
        "report_user".tr(context),
      ], context, post, reply, owner, date);
    }
  }

  Future<bool?> confirmPopUp(String dialogContent) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("confirmation".tr(context)),
          content: Text(dialogContent),
          actions: <Widget>[
            TextButton(
              child: Text("cancel".tr(context)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("ok".tr(context)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopupMenu(List<String> options, BuildContext context, Post post,
      bool reply, String username, String date) {
    return Row(
      children: [
        const SizedBox(width: 8.0),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          itemBuilder: (BuildContext context) => options.map((String option) {
            return PopupMenuItem(
              value: option,
              child: Text(option, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onSelected: (String value) async {
            if (value == "block_user".tr(context)) {
              final bool? confirm = await confirmPopUp(
                  "confirm_block_user".trWithArg(context, {"user": username}));
              if (confirm == true) {
                _controladorPresentacion.blockUser(username);
              }
            } else if (value == "report_user".tr(context)) {
              final bool? confirm = await confirmPopUp(
                  "confirm_report_user".trWithArg(context, {"user": username}));
              if (confirm == true) {
                if (reply) {
                  String? postId =
                      await _controladorPresentacion.getPostId(idForo, date);
                  _controladorPresentacion.mostrarReportUser(
                      context, username, "forum $idForo $postId");
                } else {
                  String? postId = await _controladorPresentacion.getPostId(
                      idForo, post.fecha);
                  _controladorPresentacion.mostrarReportUser(
                      context, username, "forum $idForo $postId");
                }
              }
            } else if (value == "delete_post".tr(context)) {
              _showDeleteOption(context, post, reply);
            } else if (value == "delete_reply".tr(context)) {
              postIden = await _controladorPresentacion.getPostId(idForo, date);
              _showDeleteOption(context, post, reply);
            }
          },
        ),
      ],
    );
  }

  void manageSignupButton(List<String> infoActividad) {
    if (mounted) {
      setState(() {
        if (estaApuntado) {
          controladorDominio.signoutFromActivity(_user?.uid, infoActividad[1]);
          estaApuntado = false;
        } else {
          controladorDominio.signupInActivity(_user?.uid, infoActividad[1]);
          scheduleNotificationsActivityDayBefore(
              infoActividad[1], infoActividad[0], infoActividad[5]);
          estaApuntado = true;
        }
      });
    }
  }

  void checkApuntado(String uid, List<String> infoactividad) async {
    setState(() {
      _isLoading = true;
    });
    bool apuntado =
        await controladorDominio.isUserInActivity(uid, infoactividad[1]);
    if (mounted) {
      setState(() {
        estaApuntado = apuntado;
        _isLoading = false;
      });
    }
  }
}
