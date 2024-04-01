import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/data/firebase_service.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  final List<String>? recomenacions;

  const MapPage(
      {Key? key, required this.controladorPresentacion, this.recomenacions});

  @override
  State<MapPage> createState() => _MapPageState(controladorPresentacion);
}

class _MapPageState extends State<MapPage> {
  late ControladorPresentacion _controladorPresentacion;
  int _selectedIndex = 0;
  late List<Actividad> activitats;
  late List<String> recomms;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _MapPageState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    activitats = _controladorPresentacion.getActivitats();
    recomms = _controladorPresentacion.getActivitatsRecomm();
  }

  BitmapDescriptor iconoArte = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoCarnaval = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoCirco = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoCommemoracion = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoRecom = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoConcierto = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoConferencia = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoExpo = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoFiesta = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoInfantil = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoRuta = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoTeatro = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoVirtual = BitmapDescriptor.defaultMarker;
  BitmapDescriptor iconoAMB = BitmapDescriptor.defaultMarker;
  IconData iconoCategoria = Icons.category;
  LatLng myLatLng = const LatLng(41.6543172, 2.2233522);
  String address = 'FIB';

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

  List<Actividad> _actividades = [];
  GoogleMapController? _mapController;
  List<String> categoriasFavoritas = ['circ', 'festes', 'activitats-virtuals'];

  double radians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

// Formula de Haversine para calcular que actividades entran en el radio del zoom de la pantalla
  double calculateDistance(LatLng from, LatLng to) {
    const int earthRadius = 6371000;
    double lat1 = radians(from.latitude);
    double lon1 = radians(from.longitude);
    double lat2 = radians(to.latitude);
    double lon2 = radians(to.longitude);

    double dLon = lon2 - lon1;
    double dLat = lat2 - lat1;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Obtener actividades del JSON para mostrarlas por pantalla
  Future<List<Actividad>> fetchActivities(LatLng center, double zoom) async {
    double radius = 500 * (16 / zoom);
    var actividadesaux = <Actividad>[];
    for (var actividad in activitats) {
      // Comprobar si la actividad está dentro del radio
      if (calculateDistance(center,
              LatLng(actividad.latitud ?? 0.0, actividad.longitud ?? 0.0)) <=
          radius) {
        actividadesaux.add(actividad);
      }
    }
    return actividadesaux;
  }

  @override
  void initState() {
    getIcons();
    super.initState();
  }

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

  void showActividadDetails(Actividad actividad) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              //Columna y dentro de ella filas, 1 para foto + atributos con mas filas dentro, y la descripcion y boton separados.
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //Imagen
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 150.0,
                          width: 150.0,
                          child: Image.network(
                            actividad.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Widget de error que se mostrará si la imagen no se carga correctamente
                              return const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Flexible(
                        // Para que los textos se ajusten bien
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start, // Que los textos empiezen en el ''inicio''
                              children: [
                                Flexible(
                                  child: Text(
                                    actividad.name,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(right: 5.0)),
                                _retornaIcon(actividad.categoria[
                                    0]), //Obtener el icono de la categoria
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 7.5)),
                            Row(
                              // Atributos - icono + info
                              children: [
                                const Icon(Icons.location_on),
                                const Padding(
                                    padding: EdgeInsets.only(right: 7.5)),
                                Expanded(
                                  child: Text(
                                    actividad.ubicacio,
                                    overflow: TextOverflow
                                        .ellipsis, //Poner puntos suspensivos para evitar pixel overflow
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const Padding(
                                    padding: EdgeInsets.only(right: 7.5)),
                                Text(actividad.dataInici),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const Padding(
                                    padding: EdgeInsets.only(right: 7.5)),
                                Text(actividad.dataFi),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_atm),
                                const Padding(
                                    padding: EdgeInsets.only(right: 7.5)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      launchUrl(actividad
                                          .urlEntrades); // abrir la url de la actividad para ir a su pagina
                                    },
                                    child: const Text(
                                      'Informació Entrades',
                                      style: TextStyle(
                                        decoration: TextDecoration
                                            .underline, // Subrayar para que se entienda que es un enlace
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    children: <Widget>[
                      Text(
                        actividad.descripcio,
                        overflow: TextOverflow
                            .ellipsis, //Poner puntos suspensivos para evitar pixel overflow
                        maxLines: 3,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: 400.0,
                        height: 35.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            List<String> act = [
                              actividad.name,
                              actividad.code,
                              actividad.categoria[0],
                              actividad.imageUrl,
                              actividad.descripcio,
                              actividad.dataInici,
                              actividad.dataFi,
                              actividad.ubicacio
                            ];
                            _controladorPresentacion.mostrarVerActividad(
                                context, act, actividad.urlEntrades);
                            //Actualizar BD + 1 Visualitzacio
                            DocumentReference docRef = _firestore
                                .collection('actividades')
                                .doc(actividad.code);
                            await _firestore
                                .runTransaction((transaction) async {
                              DocumentSnapshot snapshot =
                                  await transaction.get(docRef);
                              int currentValue = 0;
                              if (snapshot.data() is Map<String, dynamic>) {
                                currentValue = (snapshot.data() as Map<String,
                                        dynamic>)['visualitzacions'] ??
                                    5;
                              }
                              int newValue = currentValue + 1;
                              transaction.update(
                                  docRef, {'visualitzacions': newValue});
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                          child: const Text(
                            "Ver más información",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Crea y ubica los marcadores
  Set<Marker> _createMarkers() {
    return _actividades.map((actividad) {
      return Marker(
        markerId: MarkerId(actividad.code),
        position: LatLng(actividad.latitud, actividad.longitud),
        infoWindow: InfoWindow(title: actividad.name),
        icon: _getMarkerIcon(actividad.categoria[0],
            actividad.code), // Llama a la función para obtener el icono
        onTap: () => showActividadDetails(actividad),
      );
    }).toSet();
  }

  // En funcion de la categoria atribuye un marcador
  BitmapDescriptor _getMarkerIcon(String categoria, String code) {
    for (int i = 0; i < recomms.length; ++i) {
      if (recomms[i] == code) categoria = 'recom';
    }
    if (catsAMB.contains(categoria)) {
      return iconoAMB;
    } else {
      switch (categoria) {
        case 'carnavals':
          return iconoCarnaval;
        case 'teatre':
          return iconoTeatro;
        case 'concerts':
          return iconoConcierto;
        case 'circ':
          return iconoCirco;
        case 'exposicions':
          return iconoArte;
        case 'conferencies':
          return iconoConferencia;
        case 'commemoracions':
          return iconoCommemoracion;
        case 'rutes-i-visites':
          return iconoRuta;
        case 'cursos':
          return iconoExpo;
        case 'activitats-virtuals':
          return iconoVirtual;
        case 'infantil':
          return iconoInfantil;
        case 'festes':
          return iconoFiesta;
        case 'festivals-i-mostres':
          return iconoFiesta;
        case 'dansa':
          return iconoFiesta;
        case 'cicles':
          return iconoExpo;
        case 'cultura-digital':
          return iconoExpo;
        case 'fires-i-mercats':
          return iconoInfantil;
        case 'gegants':
          return iconoFiesta;
        case 'sardahes':
          return iconoFiesta;
        default:
          return iconoRecom;
      }
    }
  }

  //Carga los marcadores de los PNGs
  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinarte.png');
    setState(() {
      iconoArte = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinfesta.png');
    setState(() {
      iconoFiesta = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pinreciclar.png');
    setState(() {
      iconoAMB = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinrecom.png');
    setState(() {
      iconoRecom = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pinteatre.png');
    setState(() {
      iconoTeatro = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinexpo.png');
    setState(() {
      iconoExpo = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinconfe.png');
    setState(() {
      iconoConferencia = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pincarnaval.png');
    setState(() {
      iconoCarnaval = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pincirc.png');
    setState(() {
      iconoCirco = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pincommemoracio.png');
    setState(() {
      iconoCommemoracion = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pinconcert.png');
    setState(() {
      iconoConcierto = icon;
    });
    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinruta.png');
    setState(() {
      iconoRuta = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pinconcert.png');
    setState(() {
      iconoConcierto = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pininfantil.png');
    setState(() {
      iconoInfantil = icon;
    });
    icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/pinvirtual.png');
    setState(() {
      iconoVirtual = icon;
    });
  }

  //Cuando la pantalla se mueve se recalcula la posicon y el zoom para volver a calcular las actividades que tocan
  void _onCameraMove(CameraPosition position) {
    if (_mapController != null) {
      _mapController!.getZoomLevel().then((zoom) {
        fetchActivities(position.target, zoom).then((value) {
          setState(() {
            _actividades = value;
          });
        });
      });
    }
  }

  //Se crea el mapa y atribuye a la variable mapa
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  var querySearch = '';
  late Actividad activitat;

  void moveMapToSelectedActivity() {
    LatLng activityPosition =
        LatLng(activitat.latitud ?? 0.0, activitat.longitud ?? 0.0);
    _mapController?.animateCamera(CameraUpdate.newLatLng(activityPosition));
  }

  Future<void> busquedaActivitat(String querySearch) async {
    //de moment res pq això es per backend
    //Metropolitan Union Quartet
    List<Actividad> llista =
        (await _controladorPresentacion.searchActivitat(querySearch));
    activitat = llista.first;
    moveMapToSelectedActivity();
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
  //Se crea la ''pantalla'' para el mapa - falta añadir dock inferior y barra de busqueda
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Stack(
        fit: StackFit.expand, // Ajusta esta línea
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: myLatLng, zoom: 16),
            markers: _createMarkers(),
            onCameraMove: _onCameraMove,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 50.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                    //en aquest cas, només "onPressed pq només pot haver-hi una"
                    decoration: InputDecoration(
                        hintText: 'Buscar...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            onPressed: () {
                              busquedaActivitat(querySearch);
                            },
                            icon: const Icon(Icons.search))),
                    onChanged: (value) {
                      querySearch = value;
                    }),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Barra gris del botón
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        "${_actividades.length} Actividades disponibles",
                        style: const TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            SizedBox(
                              height: 750,
                              child: ListaActividadesDisponibles(actividades: _actividades, controladorPresentacion: _controladorPresentacion,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
