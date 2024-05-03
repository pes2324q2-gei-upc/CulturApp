import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";

class ModificarParticipantsScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Grup grup;

  const ModificarParticipantsScreen(
      {Key? key, required this.controladorPresentacion, required this.grup})
      : super(key: key);

  @override
  State<ModificarParticipantsScreen> createState() =>
      _ModificarParticipantsScreen(this.controladorPresentacion, this.grup);
}

class _ModificarParticipantsScreen extends State<ModificarParticipantsScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late List<bool> participantAfegit;
  late List<Usuari> displayList;
  late List<Usuari> amics;
  late Grup _grup;
  late List<String> participants;

  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _ModificarParticipantsScreen(
      ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
    amics = [];
    participants = [];
    participantAfegit = [];
    displayList = [];
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    String userName = _controladorPresentacion.getUsername();
    List<String> llistaNoms =
        await _controladorPresentacion.getFollowUsers(userName, "followers");

    amics = await convertirStringEnUsuari(
        _grup.membres.map((dynamic obj) => obj.toString()).toList());

    List<Usuari> llistaFollowers = await convertirStringEnUsuari(llistaNoms);
    for (Usuari usuari in llistaFollowers) {
      for (Usuari amic in amics) {
        if (amic.nom == usuari.nom) {
          llistaFollowers.remove(usuari);
          if (llistaFollowers.isEmpty) {
            break;
          }
        }
      }
      if (llistaFollowers.isEmpty) {
        break;
      }
    }

    amics.addAll(
        llistaFollowers); //s'uneixen els followers per si vols afegir someone

    setState(() {
      displayList = List.from(amics);
      participantAfegit = List.generate(
        displayList.length,
        (index) => !_grup.membres.contains(displayList[index]),
      );
      participants = List.from(_grup.membres as Iterable);
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
        backgroundColor: Colors.orange,
        title: Text(
          'modify_participants'.tr(context),
          style: const TextStyle(color: Colors.white),
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
                      'select_unselect_participants'.tr(context),
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
              child: _buildConfirmButton(),
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
              child: const Image(
                image: AssetImage(
                    'assets/userImage.png'), //AssetImage(participants[index].image),
                fit: BoxFit.fill,
                width: 55.0,
                height: 55.0,
              ),
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
                    participants[index],
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
            color: Colors.orange,
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
            afegirParticipant(displayList[index].nom);
          } else {
            // Remove participant if button is toggled off
            participants.remove(displayList[index].nom);
          }
        });
      },
      child: Text(
        participantAfegit[index] ? '-' : '+',
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.check),
      onPressed: () {
        _grup.membres = participants;

        //crida al backend per passar el grup updated
        _controladorPresentacion.mostrarInfoGrup(context, _grup);
      },
    );
  }
}
