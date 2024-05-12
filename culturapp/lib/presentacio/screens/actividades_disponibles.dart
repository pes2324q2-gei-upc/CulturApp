import 'package:flutter/material.dart';

class YourNormalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Actividades'),
      ),
      body: ListView.builder(
        itemCount: 10, // Número de elementos en tu lista de actividades
        itemBuilder: (context, index) {
          // Construye cada elemento de la lista de actividades aquí
          return ListTile(
            title: Text('Actividad $index'),
            subtitle: Text('Descripción de la actividad $index'),
            onTap: () {
              // Acción al hacer tap en una actividad
              // Puedes agregar aquí la lógica para abrir más detalles de la actividad, etc.
            },
          );
        },
      ),
    );
  }
}
