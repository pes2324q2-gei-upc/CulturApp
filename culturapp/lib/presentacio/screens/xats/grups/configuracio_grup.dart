import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class ConfigGrup extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final List<String> participants;

  const ConfigGrup(
      {Key? key,
      required this.controladorPresentacion,
      required this.participants})
      : super(key: key);

  @override
  State<ConfigGrup> createState() =>
      _ConfigGrup(this.controladorPresentacion, this.participants);
}

class _ConfigGrup extends State<ConfigGrup> {
  late ControladorPresentacion _controladorPresentacion;
  double llargadaPantalla = 440;
  double llargadaPantallaTitols = 438;
  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  bool afegit = false;

  List<String> _participants = [];

  /*'participant1',
    'participant2',
    'participant3',
    'participant4',
    'participant5',
    'participant6', */

  _ConfigGrup(ControladorPresentacion controladorPresentacion,
      List<String> participants) {
    _controladorPresentacion = controladorPresentacion;
    _participants = participants;
  }

  void assignarNomGrup(String value) {
    //ficar valor a "nom" de Grup
  }

  void crearGrup() {
    //funcio de post al back
    _controladorPresentacion.mostrarXats(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Configuració Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildEscollirImatge(),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildInsertarNom(),
                    ],
                  ),
                  Column(
                    children: [
                      _buildInsertarDescripcio(),
                      _buildLlistarParticipants(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: _buildCrearGrupButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEscollirImatge() {
    return Column(
      children: [
        const Text(
          'Imatge (opt):',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Image(
            image: AssetImage('assets/userImage.png'),
            fit: BoxFit.fill,
            width: 70.0,
            height: 70.0,
          ),
        ),
      ],
    );
  }

  Widget _buildInsertarNom() {
    return Column(
      children: [
        Container(
          width: 238,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nom:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SizedBox(
          width: 240,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextField(
              cursorColor: Colors.white,
              cursorHeight: 20,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Nom del grup...',
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsertarDescripcio() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          width: llargadaPantallaTitols,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Descripció:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Container(
          width: llargadaPantalla,
          height: 155,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5),
          child: TextField(
            maxLines: 6,
            cursorColor: Colors.white,
            cursorHeight: 20,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Descripció del grup...',
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLlistarParticipants() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          width: llargadaPantallaTitols,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Participants:',
            selectionColor: Colors.blue,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          width: llargadaPantalla,
          child: ListView.builder(
            itemCount: _participants.length,
            itemBuilder: (context, index) => _buildParticipant(context, index),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      //una vegada tingui mes info del model
      //dels perfils lo seu seria canviar-ho
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image(
        image: AssetImage('assets/userImage.png'),
        fit: BoxFit.fill,
        width: 50.0,
        height: 50.0,
      ),
      title: Text(_participants[index],
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildCrearGrupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: taronjaFluix,
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.check),
      onPressed: () {
        crearGrup();
      },
    );
  }
}
