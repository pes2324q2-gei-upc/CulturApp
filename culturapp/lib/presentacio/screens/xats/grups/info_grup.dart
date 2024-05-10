import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart";
import "package:culturapp/translations/AppLocalizations";
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

  Color taronjaVermellos = const Color(0xFFF4692A);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _InfoGrupScreen(ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
  }

  void canviarEstat() {
    setState(() {
      //si passa de editar a no editar es cridaria la funció de update grup per modificar-lo

      if (estaEditant) {
        _controladorPresentacion.updateGrup(_grup.id, _grup.nomGroup,
            _grup.descripcio, _grup.imageGroup, _grup.membres);
        //crida a funcio del back per fer un update de _grup amb els nous parametres
      }
      estaEditant = !estaEditant;
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
              top: 20.0,
              right: 20.0,
              child: _buildEditarGrupButton(),
            ),
            Positioned(
              bottom: 330.0,
              right: 20.0,
              child: _buildEditarParticipantsButton(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: taronjaVermellos,
      centerTitle: true,
      title: Text(
        estaEditant ? 'editing_group'.tr(context) : 'group_info'.tr(context),
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
        Text(
          'image'.tr(context),
          style: const TextStyle(
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
    return const Image(
      image: AssetImage(
          'assets/userImage.png'), //quan s'implementi les imatges ja es tocarà
      fit: BoxFit.fill,
      width: 70.0,
      height: 70.0,
    );
  }

  Widget _imatgeEditant() {
    //ns com es faria pero s'ha de poder canviar l'imatge amb una foto del movil
    return const Image(
      image: AssetImage('assets/userImage.png'),
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
          child: Text(
            'description'.tr(context),
            style: const TextStyle(
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'participants'.tr(context),
                  style: const TextStyle(
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
                    itemCount: _grup.membres.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          userBox(
                            text: _grup.membres[index],
                            recomm: false,
                            type: "null",
                            controladorPresentacion: _controladorPresentacion,
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditarParticipantsButton() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(left: 191.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: taronjaVermellos,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          //go to the pagina of modificar participants
          _controladorPresentacion.mostrarModificarParticipants(context, _grup);
        },
        child: const Icon(Icons.mode),
      ),
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: const Image(
        image: AssetImage(
            'assets/userImage.png'), //AssetImage(getImageMember(_grup.membres[index])),
        fit: BoxFit.fill,
        width: 50.0,
        height: 50.0,
      ),
      title: Text(_grup.membres[index],
          style: TextStyle(
            color: taronjaVermellos,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildEditarGrupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: taronjaVermellos,
        foregroundColor: Colors.white,
      ),
      onPressed: canviarEstat,
      child: Icon(estaEditant ? Icons.check : Icons.mode),
    );
  }
}
