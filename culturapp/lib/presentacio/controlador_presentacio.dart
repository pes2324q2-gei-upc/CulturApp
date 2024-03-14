import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:flutter/material.dart';



class ControladorPresentacion {

  final controladorDomini = ControladorDomini();

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  Future <List<Actividad>> getActivities() async {

    return await controladorDomini.getActivities();

  }
}