import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/widgets/user_info.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PerfilPage extends StatefulWidget {
  
  final ControladorPresentacion controladorPresentacion;

  const PerfilPage({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState(this.controladorPresentacion);
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;
  late ControladorPresentacion _controladorPresentacion;
  
  _PerfilPageState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
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
    body: const Stack(
        children: [
          UserInfoWidget(), // Calling the UserInfoWidget
        ],
      ),
    //container amb les diferents pantalles
    );
  }
}