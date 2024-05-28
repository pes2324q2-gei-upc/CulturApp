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

  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);

  _CrearGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;

    amics = []; //allAmics;
    participantAfegit = [];
    _loadFriends();
    displayList = amics;
  }

  List<Usuari> participants = [];

  Future<void> _loadFriends() async {
    String userName = _controladorPresentacion.getUsername();
    List<String> llistaNoms =
        await _controladorPresentacion.getFollowUsers(userName, "followers");

    amics = await convertirStringEnUsuari(llistaNoms);

    setState(() {
      displayList = List.from(amics);
      participantAfegit = List.filled(displayList.length, false);
    });
  }

  Future<List<Usuari>> convertirStringEnUsuari(List<String> llistaNoms) async {
    List<Usuari> llistaUsuaris = [];

    for (String nom in llistaNoms) {
      Usuari user = await _controladorPresentacion.getUserByName(nom);
      llistaUsuaris.add(user);
    }

    return llistaUsuaris;
  }

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
        backgroundColor: taronjaVermellos,
        centerTitle: true,
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
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0, top: 30.0),
                    child: Text(
                      'choose_participants'.tr(context),
                      style: const TextStyle(
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
      height: 45.0, // Altura del contenedor para el TextField
      child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 15.0, top: 2.0),
              child: Center(
                child: TextField(
                  onChanged: (value) => updateList(value),
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'search'.tr(context),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                  ),
                ),
              ),
            ),
          )),
    );
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
              child: participants[index].image.isNotEmpty
                ? ClipOval(
                    child: Image(
                      image: NetworkImage(participants[index].image),
                      fit: BoxFit.fill,
                      width: 55.0,
                      height: 55.0,
                    ),
                  )
                : Image.asset(
                    'assets/userImage.png',
                    fit: BoxFit.fill,
                    width: 55.0,
                    height: 55.0,
                  ),
            ),
            Positioned(
              left: 10,
              bottom: 9,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the radius as needed
                child: Container(
                  color: taronjaVermellosFluix,
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
      leading: displayList[index].image.isNotEmpty
        ? ClipOval(
            child: Image(
              image: NetworkImage(displayList[index].image),
              fit: BoxFit.fill,
              width: 50.0,
              height: 50.0,
            ),
          )
          : const Image(
            image: AssetImage('assets/userImage.png'),
            fit: BoxFit.fill,
            width: 50.0,
            height: 50.0,
          ), // Placeholder widget to show if there's no image
      title: Text(displayList[index].nom,
          style: TextStyle(
            color: taronjaVermellos,
            fontWeight: FontWeight.bold,
          )),
      trailing: _buildBotoAfegir(displayList[index], index),
    );
  }

  Widget _buildBotoAfegir(participant, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: taronjaVermellosFluix,
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
  }

  Widget _buildNextPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: taronjaVermellos,
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.arrow_forward),
      onPressed: () {
        if (participants.isNotEmpty)
          _controladorPresentacion.mostrarConfigGrup(context, participants);
      },
    );
  }
}
