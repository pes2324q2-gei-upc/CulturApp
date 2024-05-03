import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("Activity".tr(context)),
        centerTitle: true, // Centrar el título
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
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
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: ListView(
        children: [
          _imagenActividad(infoActividad[3]), 
          _tituloBoton(infoActividad[0], (infoActividad[2].split(","))[0]), 
          const SizedBox(height: 10),
          _descripcioActividad(infoActividad[4]), 
          _expansionDescripcion(),
          _infoActividad(infoActividad[7], infoActividad[5], infoActividad[6], infoActividad[2], uriActividad),
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
                  child: Text(
                    'tickets_info'.tr(context),
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

