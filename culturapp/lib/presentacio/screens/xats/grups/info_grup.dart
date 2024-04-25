import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class InfoGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Grup grup;

  const InfoGrupScreen(
      {Key? key, required this.controladorPresentacion, required this.grup})
      : super(key: key);

  @override
  State<InfoGrupScreen> createState() =>
      _InfoGrupScreen(this.controladorPresentacion, this.grup);
}

class _InfoGrupScreen extends State<InfoGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late Grup _grup;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _InfoGrupScreen(ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
    //nomParticipants = agafarNomsParticipants(_grup.participants);
    //missatges = _grup.missatgesGrup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Text('hello'),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      title: const Text(
        'Informació Grup',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
