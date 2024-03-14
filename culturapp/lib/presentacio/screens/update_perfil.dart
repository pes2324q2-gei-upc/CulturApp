import 'package:flutter/material.dart';

class UpdatePerfil extends StatefulWidget {
  const UpdatePerfil({super.key});

  @override
  State<UpdatePerfil> createState() => _UpdatePerfil();
}

class _UpdatePerfil extends State<UpdatePerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Actualitza Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Stack(
        children: [
          Text("Aqui anira el form per actualitzar perfil")
        ],
      ),
    );
  }
}