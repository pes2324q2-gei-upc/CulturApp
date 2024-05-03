import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";

class CrearGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const CrearGrupScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<CrearGrupScreen> createState() =>
      _CrearGrupScreen(this.controladorPresentacion);
}

class _CrearGrupScreen extends State<CrearGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late List<bool> participantAfegit;
  late List<Usuari> displayList;
  late List<Usuari> amics;
  //o millor fer-ho dels noms només?? -> millor en usuaris pq després els haurem de passar per fer un grup

  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _CrearGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    amics = allAmics;
    displayList = amics;
    participantAfegit = List.filled(displayList.length, false);
  }

  List<Usuari> participants = [];

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista (cercador)
    setState(
      () {
        displayList = amics
            .where((element) =>
                element.nom.toLowerCase().contains(value.toLowerCase()))
            .toList();
      },
    );
  }

  void afegirParticipant(participant) {
    setState(() {
      participants.add(participant);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text(
          'Crear Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0, top: 30.0),
                    child: Text(
                      'choose_participants'.tr(context),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                _buildCercador(),
                const SizedBox(
                  height: 10.0,
                ),
                _buildAfegits(),
                Container(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
                  height: 460.0,
                  child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) =>
                        _buildParticipant(context, index),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: _buildNextPageButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCercador() {
    return SizedBox(
        height: 40.0,
        width: 350.0,
        child: TextField(
          onChanged: (value) => updateList(value),
          cursorColor: Colors.white,
          cursorHeight: 20,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: taronja_fluix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: "search".tr(context),
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            suffixIcon: const Icon(Icons.search),
            suffixIconColor: Colors.white,
          ),
        ));
  }

  Widget _buildAfegits() {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      alignment: Alignment.centerLeft,
      height: 75,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return _buildParticipantAfegit(context, index);
        },
      ),
    );
  }

  Widget _buildParticipantAfegit(context, index) {
    return SizedBox(
      width: 80.0,
      height: 60.0,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage(participants[index].image),
                fit: BoxFit.fill,
                width: 55.0,
                height: 55.0,
              ),
              //),
            ),
            Positioned(
              bottom: 9,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the radius as needed
                child: Container(
                  color: taronja_fluix.withOpacity(0.90),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    participants[index].nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image(
        image: AssetImage(displayList[index].image),
        fit: BoxFit.fill,
        width: 50.0,
        height: 50.0,
      ),
      title: Text(displayList[index].nom,
          style: const TextStyle(
            color: const Color(0xFFF4692A),
            fontWeight: FontWeight.bold,
          )),
      trailing: _buildBotoAfegir(displayList[index], index),
    );
  }

  Widget _buildBotoAfegir(participant, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        setState(() {
          participantAfegit[index] = !participantAfegit[index];
          if (participantAfegit[index]) {
            afegirParticipant(displayList[index]);
          } else {
            // Remove participant if button is toggled off
            participants.remove(displayList[index]);
          }
        });
      },
      child: Text(
        participantAfegit[index] ? '-' : '+',
      ),
    );
  } //com de moment no tinc l'estructura dels models
  //dels participant i això serà un atribut d'ells, no val la pena continuar de moment

  Widget _buildNextPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.arrow_forward),
      onPressed: () {
        _controladorPresentacion.mostrarConfigGrup(context, participants);
      },
    );
  }
}
