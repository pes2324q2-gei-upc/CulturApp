import 'package:culturapp/actividad/vista_ver_actividad.dart';
import 'package:flutter/material.dart';



class ControladorPresentacion {

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }
}