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
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Seetings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: 
      //hacer widget con el listado de todo
      //privacidad
      SwitchListTile(
        title: const Text("Privacidad"),
        value: privat, 
        onChanged: (bool value) {
          setState(() {
            privat = value;
          });
        },
        secondary: const Icon(Icons.lock),
      )
      
      /*Stack(
        children: [
          Text("Aqui anira totes les configuracions de la app")
          
          //lista de cuentas bloqueadas
          //idioma
          
          const ListTile(
            title: Text("Account"),
          ),

          //cambiar contraseña
          //logout
          //delete account
          
          //tema de notificaciones?
        ],
      ),
      */
    );
  }
}