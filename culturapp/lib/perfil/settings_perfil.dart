import 'package:flutter/material.dart';

class SettingsPerfil extends StatefulWidget {
  const SettingsPerfil({super.key});

  @override
  State<SettingsPerfil> createState() => _SettingsPerfil();
}

class _SettingsPerfil extends State<SettingsPerfil> {
  bool privat = false;
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
              //cerrar sesión
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
        ],
      )
    );
      //hacer widget con el listado de todo
      
      
      /*Stack(
        children: [

          //logout
          //delete account
          
          //tema de notificaciones?
        ],
      ),
      */
  }
}