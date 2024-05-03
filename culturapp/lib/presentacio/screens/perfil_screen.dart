import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/widgets/user_info.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PerfilPage extends StatefulWidget {
  
  final ControladorPresentacion controladorPresentacion;
  final String username;
  final bool owner;

  const PerfilPage({Key? key, required this.controladorPresentacion, required String this.username, required bool this.owner}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState(this.controladorPresentacion, this.username, this.owner);
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;
  late ControladorPresentacion _controladorPresentacion;
  late String _username;
  late bool _owner;
  
  _PerfilPageState(ControladorPresentacion controladorPresentacion, String username, bool owner) {
    _controladorPresentacion = controladorPresentacion;
    _username = username;
    _owner = owner;
  }

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
      backgroundColor: const Color(0xFFF4692A),
      title: Text(
        'profile'.tr(context),
        style: TextStyle(color: Colors.white),
      ),
      //botons
        actions: _owner ? [
          IconButton(
            onPressed: () {
              
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _controladorPresentacion.mostrarEditPerfil(this.context, _username);
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
        ] : [],
      ),
    bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
    ),
    body: UserInfoWidget(controladorPresentacion: _controladorPresentacion, username: _username, owner: widget.owner),
    );
  }

}