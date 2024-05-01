import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:flutter/material.dart';

class UpdatePerfil extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const UpdatePerfil({super.key, required this.controladorPresentacion});

  @override
  State<UpdatePerfil> createState() => _UpdatePerfil(this.controladorPresentacion);
}

class _UpdatePerfil extends State<UpdatePerfil> {
  late ControladorPresentacion _controladorPresentacion;

  _UpdatePerfil(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Actualiza Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Stack(
        children: [
          Text("Aqui ira el form para actualizar el perfil")
        ],
      ),
    );
  }
}