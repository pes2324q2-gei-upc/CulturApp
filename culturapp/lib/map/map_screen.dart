import 'dart:convert';
import 'dart:math' as math;

import 'package:culturapp/actividad/vista_ver_actividad.dart';
import 'package:culturapp/actividades/actividad.dart';
import 'package:culturapp/controlador_presentacion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {

  final ControladorPresentacion controladorPresentacion;
  
  const MapPage({Key? key, required this.controladorPresentacion});

  @override
  State<MapPage> createState() => _MapPageState(controladorPresentacion);
}

class _MapPageState extends State<MapPage> {

  late ControladorPresentacion _controladorPresentacion;  

  _MapPageState(ControladorPresentacion controladorPresentacion){
    _controladorPresentacion = controladorPresentacion;
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
  IconData iconoCategoria = Icons.category;
  LatLng myLatLng = const LatLng(41.389350, 2.113307);
  String address = 'FIB';
  List<String> categoriasFavoritas = ['circ', 'festes', 'activitats-virtuals'];
  List<Actividad> _actividades = [];
  GoogleMapController? _mapController;

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
    double radius = 1000 * (16 / zoom);
    var url = Uri.parse("https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    var response = await http.get(url);
    var actividades = <Actividad>[];

    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        // Comprobar si la actividad está dentro del radio
        if (calculateDistance(center, LatLng(actividad.latitud, actividad.longitud)) <= radius) {
          actividades.add(actividad);
        }
      }
    }
    return actividades;
  }

  @override
  void initState() {
    getIcons();
    super.initState();
  }

  Image _retornaIcon (String categoria){
      switch (categoria) {
      case 'carnavals':
        return Image.asset('assets/categoriacarnaval.png', width: 45.0,);
      case 'teatre':
        return Image.asset('assets/categoriateatre.png', width: 45.0,);
      case 'concerts':
        return Image.asset('assets/categoriaconcert.png', width: 45.0,);
      case 'circ':
        return Image.asset('assets/categoriacirc.png', width: 45.0,);
      case 'exposicions':
        return Image.asset('assets/categoriaarte.png', width: 45.0,);
      case 'conferencies':
        return Image.asset('assets/categoriaconfe.png', width: 45.0,);
      case 'commemoracions':
        return Image.asset('assets/categoriacommemoracio.png', width: 45.0,);
      case 'rutes-i-visites':
        return Image.asset('assets/categoriaruta.png', width: 45.0,);
      case 'cursos':
        return Image.asset('assets/categoriaexpo.png', width: 45.0,);
      case 'activitats-virtuals':
        return Image.asset('assets/categoriavirtual.png', width: 45.0,);
      case 'infantil':
        return Image.asset('assets/categoriainfantil.png', width: 45.0,);
      case 'festes':
        return Image.asset('assets/categoriafesta.png', width: 45.0,);
      case 'festivals-i-mostres':
        return Image.asset('assets/categoriafesta.png', width: 45.0,);
      case 'dansa':
        return Image.asset('assets/categoriafesta.png', width: 45.0,);
      case 'cicles':
        return Image.asset('assets/categoriaexpo.png', width: 45.0,);
      case 'cultura-digital':
        return Image.asset('assets/categoriavirtual.png', width: 45.0,);
      case 'fires-i-mercats':
        return Image.asset('assets/categoriainfantil.png', width: 45.0,);
      case 'gegants':
        return Image.asset('assets/categoriafesta.png', width: 45.0,);
      default:
        return Image.asset('assets/categoriarecom.png', width: 45.0,);
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
                        child: SizedBox( // se mete aqui la imagen para poder modificar su tamaño
                          height: 150.0,
                          width: 150.0,
                          child: Image.network(
                            actividad.imageUrl,
                            fit: BoxFit.cover, // Para que ocupe lo mismo que nombre + atributos
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Flexible( // Para que los textos se ajusten bien
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Que los textos empiezen en el ''inicio''
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
                                const Padding(padding: EdgeInsets.only(right: 5.0)),
                                _retornaIcon(actividad.categoria), //Obtener el icono de la categoria
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 7.5)),
                            Row(
                              // Atributos - icono + info
                              children: [
                                const Icon(Icons.location_on),
                                const Padding(padding: EdgeInsets.only(right: 7.5)),
                                Expanded(
                                  child: Text(
                                    actividad.ubicacio,
                                    overflow: TextOverflow.ellipsis, //Poner puntos suspensivos para evitar pixel overflow
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const Padding(padding: EdgeInsets.only(right: 7.5)),
                                Text(actividad.dataInici),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                const Padding(padding: EdgeInsets.only(right: 7.5)),
                                Text(actividad.dataFi),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_atm),
                                const Padding(padding: EdgeInsets.only(right: 7.5)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      launchUrl(actividad.urlEntrades); // abrir la url de la actividad para ir a su pagina
                                    },
                                    child: const Text(
                                      'Informació Entrades',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline, // Subrayar para que se entienda que es un enlace
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
                        actividad.description,
                        overflow: TextOverflow.ellipsis,  //Poner puntos suspensivos para evitar pixel overflow
                        maxLines: 3,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: 400.0,
                        height: 35.0,
                        child: ElevatedButton(
                          onPressed: () {
                            List<String> act = [actividad.name, 
                                                actividad.code, 
                                                actividad.categoria,
                                                actividad.imageUrl, 
                                                actividad.description, 
                                                actividad.dataInici,
                                                actividad.dataFi, 
                                                actividad.ubicacio];

                            _controladorPresentacion.mostrarVerActividad(context, act, actividad.urlEntrades);                    
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.orange),
                          ),
                          child: const Text(
                            "Ver más información",
                            style: TextStyle(
                              color: Colors.white
                              ),
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
        icon: _getMarkerIcon(actividad.categoria), // Llama a la función para obtener el icono
        onTap: () => showActividadDetails(actividad),
      );
    }).toSet();
  }

  // En funcion de la categoria atribuye un marcador
  BitmapDescriptor _getMarkerIcon(String categoria) {
    
    for (int i = 0; i < 3; ++i) {
      if (categoria == categoriasFavoritas[i]) categoria = 'recom';
    }

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
        default:
          return iconoRecom;
      }
  }
  //Carga los marcadores de los PNGs
  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinarte.png');
    setState(() {
      iconoArte = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinfesta.png');
    setState(() {
      iconoFiesta = icon;
    });
    
    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinrecom.png');
    setState(() {
      iconoRecom = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinteatre.png');
    setState(() {
      iconoTeatro = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinexpo.png');
    setState(() {
      iconoExpo = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinconfe.png');
    setState(() {
      iconoConferencia = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pincarnaval.png');
    setState(() {
      iconoCarnaval = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pincirc.png');
    setState(() {
      iconoCirco = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pincommemoracio.png');
    setState(() {
      iconoCommemoracion = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinconcert.png');
    setState(() {
      iconoConcierto = icon;
    });
    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinruta.png');
    setState(() {
      iconoRuta = icon;
    });

    icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinconcert.png');
    setState(() {
      iconoConcierto = icon;
    });

  icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pininfantil.png');
    setState(() {
      iconoInfantil = icon;
    });
  icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5), 'assets/pinvirtual.png');
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


  void _onTabChange(int index) {
    /*switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        
        break;
      case 3:

        break;
      default:
        break;
    }*/
  }


  //Se crea la ''pantalla'' para el mapa - falta añadir dock inferior y barra de busqueda
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
      child: GNav(
        backgroundColor: Colors.white,
        color: Colors.orange,
        activeColor: Colors.orange,
        tabBackgroundColor: Colors.grey.shade100,
        gap: 6,
        onTabChange: (index) {
          _onTabChange(index);
        },
        selectedIndex: 0,
        tabs: const [
          GButton(text: "Mapa", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.map),
          GButton(text: "Mis Actividades", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.event),
          GButton(text: "Chats", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.chat),
          GButton(text: "Perfil", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.person),
        ],
      ),
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: myLatLng, zoom: 12),
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
              child: const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
