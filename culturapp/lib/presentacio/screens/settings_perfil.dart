import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:culturapp/presentacio/screens/login.dart';

class SettingsPerfil extends StatefulWidget {

  final ControladorPresentacion controladorPresentacion;

  const SettingsPerfil({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  State<SettingsPerfil> createState() => _SettingsPerfil(this.controladorPresentacion);
}

class _SettingsPerfil extends State<SettingsPerfil> {
  //Usuari de Firebase
  User? _user;
  int _selectedIndex = 3;

  //Instancia de autentificacio de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late ControladorPresentacion _controladorPresentacion;

  bool privat = false;
  
  _SettingsPerfil(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
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
      //Header
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Seetings',
          style: TextStyle(color: Colors.white),
        ),
      ),      
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      //opcions de configuracio
      body: Column (
        children: [
          //privacidad
          SwitchListTile(
            title: const Text("Privacidad"),
            subtitle: const Text("Explicacion de lo que implicaria tener la cuenta privada"),
            value: privat, 
            onChanged: (bool value) {
              setState(() {
                privat = value;
              });
            },
            secondary: const Icon(Icons.lock),
          ),
          const Divider(height: 0),
          //idioma
          ListTile(
            title: const Text('Idioma'),
            subtitle: const Text("Cambiar el idioma"),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // pantalla de selección de idioma
            },
          ),
          const Divider(height: 0),
          //contraseña
          ListTile(
            title: const Text('Cambiar Contraseña'),
            subtitle: const Text("Modificar la contraseña actual"),
            leading: const Icon(Icons.vpn_key),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              //pantalla de cambio de contraseña
            },
          ),
          const Divider(height: 0),
          //cerrar sessión
          ListTile(
            title: const Text('Cerrar Sesión'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              signout(context);
            },
          ),
          const Divider(height: 0),
          //eliminar cuenta
          ListTile(
            title: const Text('Eliminar cuenta'),
            subtitle: const Text("Borrar cuenta permanentemente"),
            leading: const Icon(Icons.delete),
            onTap: () {
              //eliminar ceunta
            },
          ),
          const Divider(height: 0),
          //si queremos, añadir tema de notificaciones
        ],
      )
    );
  }

  void signout(context) {
    _controladorPresentacion.logout(context);
  }
}