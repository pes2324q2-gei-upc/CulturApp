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
  //de moment els participants no els modifiquem

  double llargadaPantalla = 440;
  double llargadaPantallaTitols = 438;
  bool estaEditant = false;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _InfoGrupScreen(ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
  }

  void canviarEstat() {
    setState(() {
      estaEditant = !estaEditant;
      //si passa de editar a no editar es cridaria la funció de update grup per modificar-lo

      if (estaEditant) {
        //crida a funcio del back per fer un update de _grup amb els nous parametres
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildImatge(),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildNom(),
                    ],
                  ),
                  Column(
                    children: [
                      _buildDescripcio(),
                      _buildLlistarParticipants(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: _buildEditarGrupButton(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      title: Text(
        estaEditant ? 'Editant Grup' : 'Informació Grup',
        style: const TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _controladorPresentacion.mostrarXatGrup(context, _grup);
        },
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Widget _buildImatge() {
    return Column(
      children: [
        const Text(
          'Imatge:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: estaEditant ? _imatgeEditant() : _imatgeNoEditant(),
        ),
      ],
    );
  }

  Widget _imatgeNoEditant() {
    return Image(
      image: AssetImage(_grup.imageGroup),
      fit: BoxFit.fill,
      width: 70.0,
      height: 70.0,
    );
  }

  Widget _imatgeEditant() {
    //ns com es faria pero s'ha de poder canviar l'imatge amb una foto del movil
    return Image(
      image: AssetImage(_grup.imageGroup),
      fit: BoxFit.fill,
      width: 70.0,
      height: 70.0,
    );
  }

  Widget _buildNom() {
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
            child: estaEditant ? _nomGrupEditant() : _nomGrupNoEditant(),
          ),
        ),
      ],
    );
  }

  Widget _nomGrupEditant() {
    return TextField(
      cursorColor: Colors.white,
      cursorHeight: 20,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      onChanged: (value) {
        _grup.nomGroup = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        hintText: _grup.nomGroup,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _nomGrupNoEditant() {
    return Text(
      _grup.nomGroup,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescripcio() {
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
          height: 150,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5),
          child: estaEditant
              ? _descripcioGrupEditant()
              : _descripcioGrupNoEditant(),
        ),
      ],
    );
  }

  Widget _descripcioGrupEditant() {
    return TextField(
      maxLines: 6,
      cursorColor: Colors.white,
      cursorHeight: 20,
      onChanged: (value) {
        setState(() {
          _grup.descripcio = value;
        });
      },
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
        hintText: _grup.descripcio,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _descripcioGrupNoEditant() {
    return Text(
      _grup.descripcio,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLlistarParticipants() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          width: llargadaPantallaTitols,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Text(
                'Participants:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 191.0),
                height: 22,
                child: estaEditant
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: taronjaFluix,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          //go to the pagina of modificar participants
                          _controladorPresentacion.mostrarModificarParticipants(
                              context, _grup);
                        },
                        child: const Icon(Icons.format_paint_rounded),
                      )
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          width: llargadaPantalla,
          child: ListView.builder(
            itemCount: _grup.participants!.length,
            itemBuilder: (context, index) => _buildParticipant(context, index),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image(
        image: AssetImage(_grup.participants![index].image),
        fit: BoxFit.fill,
        width: 50.0,
        height: 50.0,
      ),
      title: Text(_grup.participants![index].nom,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildEditarGrupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: taronjaFluix,
        foregroundColor: Colors.white,
      ),
      onPressed: canviarEstat,
      child: Icon(estaEditant ? Icons.check : Icons.format_paint_rounded),
    );
  }
}
