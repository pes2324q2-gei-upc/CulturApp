import 'package:flutter/material.dart';

class SettingsPerfil extends StatefulWidget {
  const SettingsPerfil({super.key});

  @override
  State<SettingsPerfil> createState() => _SettingsPerfil();
}

class _SettingsPerfil extends State<SettingsPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Seetings Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Stack(
        children: [
          Text("Aqui anira totes les configuracions de la app")
        ],
      ),
    );
  }
}