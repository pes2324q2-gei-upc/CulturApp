import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class PerfilPage extends StatefulWidget {
  
  final ControladorPresentacion controladorPresentacion;

  const PerfilPage({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState(this.controladorPresentacion);
}

class _PerfilPageState extends State<PerfilPage> {
  
  late ControladorPresentacion _controladorPresentacion;
  
  _PerfilPageState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
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
            _controladorPresentacion.mostrarSettings(context);
          },
          icon: const Icon(Icons.settings, color: Colors.white),
        ),
      ],
    ),
    body: const Stack(
        children: [
          UserInfoWidget(), // Calling the UserInfoWidget
        ],
      ),
    );
  }
}