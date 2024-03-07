import 'dart:convert';
import 'dart:math' as math;

import 'package:culturapp/actividades/actividad.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

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
  
  LatLng myLatLng = const LatLng(41.389350, 2.113307);
  String address = 'FIB';

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
    double radius = 500 * (16 / zoom);
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
  
  // Crea y ubica los marcadores
  Set<Marker> _createMarkers() {
    return _actividades.map((actividad) {
      return Marker(
        markerId: MarkerId(actividad.code),
        position: LatLng(actividad.latitud, actividad.longitud),
        infoWindow: InfoWindow(title: actividad.name),
        icon: _getMarkerIcon(actividad.categoria), // Llama a la función para obtener el icono
      );
    }).toSet();
  }

  // En funcion de la categoria atribuye un marcador
  BitmapDescriptor _getMarkerIcon(String categoria) {
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
        return iconoExpo;
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
