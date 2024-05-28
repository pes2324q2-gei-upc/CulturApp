import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/converters/truncar_string.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";

class AmicsScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const AmicsScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<AmicsScreen> createState() =>
      _AmicsScreenState(this.controladorPresentacion);
}

class _AmicsScreenState extends State<AmicsScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late List<Usuari> llista_amics = [];
  late List<Usuari> displayList = [];
  bool _isDisposed = false;

  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);
  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);

  String mockImage = 'assets/userImage.png';

  _AmicsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;

    _loadFriends();
    //crida a backend per agafar tots els amics de l'usuari
  }

  String value = '';

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista(cercador)
    if (!_isDisposed) {
      setState(
        () {
          displayList = llista_amics
              .where((element) =>
                  element.nom.toLowerCase().contains(value.toLowerCase()))
              .toList();
        },
      );
    }
  }

  Future<List<Usuari>> convertirStringEnUsuari(List<String> llistaNoms) async {
    List<Usuari> llistaUsuaris = [];

    for (String nom in llistaNoms) {
      Usuari user = await _controladorPresentacion.getUserByName(nom);
      llistaUsuaris.add(user);
    }

    return llistaUsuaris;
  }

  Future<void> _loadFriends() async {
    String userName = _controladorPresentacion.getUsername();
    List<String> llistaNoms =
        await _controladorPresentacion.getFollowUsers(userName, "followers");

    llista_amics = await convertirStringEnUsuari(llistaNoms);

    if (!_isDisposed) {
      setState(() {
        displayList = List.from(llista_amics);
      });
    }
  }

  Future<String> agafarLastMessage(Usuari amic) async {
    return await _controladorPresentacion.lastMsg(amic.nom);
  }

  Future<String> agafarTimeLastMessage(Usuari amic) async {
    String time = await _controladorPresentacion.lasTime(amic.nom);
    return convertTimeFormat(time);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 40.0,
        child: _buildCercador(),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Container(
        height: 470.0,
        child: RefreshIndicator(
          onRefresh: _loadFriends,
          child: ListView.builder(
            itemCount: displayList.length,
            itemBuilder: (context, index) => _buildAmic(context, index),
          ),
        ),
      )
    ]);
  }

  Widget _buildCercador() {
    return SizedBox(
      height: 45.0, // Altura del contenedor para el TextField
      child: Padding(
        padding: const EdgeInsets.only(right: 0.0, left: 0.0),
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
        ),
      ),
    );
  }

  Widget _buildAmic(context, index) {
    //crida per getUsuari

    return GestureDetector(
      onTap: () {
        //anar cap a la pantalla de un xat amb l'usuari
        //crida al backend per agafar el xat del amic en concret
        _controladorPresentacion.getXat(displayList[index].nom);
        _controladorPresentacion.mostrarXatAmic(context, displayList[index]);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.25, color: Colors.grey),
            top: BorderSide(width: 0.25, color: Colors.grey),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          leading: Image(
            //image: AssetImage(displayList[index].image),
            image: AssetImage(mockImage),
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
          title: Text(displayList[index].nom,
              style: TextStyle(
                color: taronjaVermellos,
                fontWeight: FontWeight.bold,
              )),
          subtitle: FutureBuilder<String>(
            future: agafarLastMessage(displayList[index]),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('');
              } else {
                return Text(truncarString(snapshot.data ?? '', 24));
              }
            },
          ),
          trailing: FutureBuilder<String>(
            future: agafarTimeLastMessage(displayList[index]),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('');
              } else {
                return Text(snapshot.data ?? '');
              }
            },
          ),
        ),
      ),
    );
  }
}
