import "dart:typed_data";
import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

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
  Uint8List? _image;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
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
            _grup.descripcio, _image, _grup.membres);
        //crida a funcio del back per fer un update de _grup amb els nous parametres
      } 
      estaEditant = !estaEditant;
    });
  }

  void actualitzarInfoGrup() async {
    Grup g = await _controladorPresentacion.getInfoGrup(_grup.id);
    _grup.imageGroup = g.imageGroup;
  }

  void assignarImatge() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if(_file != null) {
      return await _file.readAsBytes();
    }
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
    actualitzarInfoGrup();
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
    return _grup.imageGroup.isNotEmpty
    ? ClipOval(
        child: Image(
          image: NetworkImage(_grup.imageGroup),
              fit: BoxFit.cover,
              width: 70.0,
              height: 70.0,
        )
      )
    : const Image(
      image: AssetImage(
          'assets/userImage.png'), 
      fit: BoxFit.fill,
      width: 70.0,
      height: 70.0,
    );
  }

  Widget _imatgeEditant() {
    return Stack (
      children: [
        _image != null 
        ? CircleAvatar(
            backgroundImage: MemoryImage(_image!),
            radius: 65,
          )
        : _grup.imageGroup.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(_grup.imageGroup),
              radius: 65,
            )
          : const CircleAvatar(
              backgroundImage: AssetImage('assets/userImage.png'),
              radius: 65,
            ),  
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: assignarImatge,
            icon: const Icon(Icons.add_a_photo),
          )
        )
      ],
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
          child: Row(
            children: [
              Text(
                'participants'.tr(context),
                style: const TextStyle(
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
            itemCount: _grup.membres.length,
            itemBuilder: (context, index) => _buildParticipant(context, index),
          ),
        ),
      ],
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
      onPressed: () {
        canviarEstat();
        actualitzarInfoGrup();
      },
      child: Icon(estaEditant ? Icons.check : Icons.format_paint_rounded),
    );
  }
}
