import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class InfoAmicScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Usuari usuari;

  const InfoAmicScreen(
      {Key? key, required this.controladorPresentacion, required this.usuari})
      : super(key: key);

  @override
  State<InfoAmicScreen> createState() =>
      _InfoAmicScreen(this.controladorPresentacion, this.usuari);
}

class _InfoAmicScreen extends State<InfoAmicScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late Usuari _usuari;

  _InfoAmicScreen(
      ControladorPresentacion controladorPresentacion, Usuari usuari) {
    _controladorPresentacion = controladorPresentacion;
    _usuari = usuari;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Expanded(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
              ),
              _buildImatge(),
              _buildNom(),
              _buildEmail(),
              const SizedBox(
                height: 20.0,
              ),
              _botoAnarPerfil(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      title: const Text(
        'Informació Amic',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _controladorPresentacion.mostrarXatAmic(context, _usuari);
        },
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Widget _buildImatge() {
    return SizedBox(
      width: 200.0,
      height: 200.0,
      child: CircleAvatar(
        backgroundImage: AssetImage(_usuari.image),
      ),
    );
  }

  Widget _buildNom() {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
        _usuari.nom,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: Text(
        _usuari.email,
        style: const TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget _botoAnarPerfil() {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          //crida al backend d'anar a un perfil d'amic
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
          //padding: MaterialStateProperty<EdgeInsetsGeometry?>(10.0),
        ),
        child: const Text(
          "Veure Perfil d'Amic",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
