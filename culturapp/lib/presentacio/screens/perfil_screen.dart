import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/widgets/user_info.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PerfilPage extends StatefulWidget {
  
  final ControladorPresentacion controladorPresentacion;
  final String uid;

  const PerfilPage({Key? key, required this.controladorPresentacion, required String this.uid}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState(this.controladorPresentacion, this.uid);
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;
  late ControladorPresentacion _controladorPresentacion;
  late String _uid;
  
  _PerfilPageState(ControladorPresentacion controladorPresentacion, String uid) {
    _controladorPresentacion = controladorPresentacion;
    _uid = uid;
  }


  //no se que es esta funcuion
  @override
  void initState() {
    
    super.initState();
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
    //header
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.orange,
      title: const Text(
        'Perfil',
        style: TextStyle(color: Colors.white),
      ),
      //boton de settings
      actions: [
        IconButton(
          onPressed: () {
            
          },
          icon: const Icon(Icons.notifications, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            _controladorPresentacion.mostrarEditPerfil(this.context, this._uid);
          },
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            //hacer que no se vea si estas viendo el perfil de otro user
            //Navigator.pushNamed(context, Routes.settings);
            _controladorPresentacion.mostrarSettings(context);
          },
          icon: const Icon(Icons.settings, color: Colors.white),
        ),
      ],
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
    ),
    body: UserInfoWidget(controladorPresentacion: _controladorPresentacion, uid: _uid),
    
    //container amb les diferents pantalles
    );
  }

}