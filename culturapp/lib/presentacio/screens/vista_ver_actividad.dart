import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

//name, code, categoria, imageUrl, description, dataInici, dataFi, ubicacio
// urlEntrades


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
  final ControladorDomini controladorDominio = new ControladorDomini();
  int _selectedIndex = 0;
  late List<String> infoActividad;
  late Uri uriActividad;

  bool mostrarDescripcionCompleta = false;
  bool estaApuntado = false;

  final User? _user = FirebaseAuth.instance.currentUser;

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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: ListView(
        children: [
          _imagenActividad(infoActividad[3]), //Accedemos imagenUrl
          _tituloBoton(infoActividad[0], infoActividad[2]), //Accedemos al nombre de la actividad y su categoria
          const SizedBox(height: 10),
          _descripcioActividad(infoActividad[4]), //Accedemos su descripcion
          _expansionDescripcion(),
          _infoActividad(infoActividad[7], infoActividad[5], infoActividad[6], uriActividad),
        ],  //Accedemos ubicación, dataIni, DataFi, uri actividad
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

