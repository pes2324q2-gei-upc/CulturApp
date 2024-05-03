import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/models/user.dart";
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
  late List<Usuari> llista_amics;
  late List<Usuari> display_list;

  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  String mockImage = 'assets/userImage.png';

  _AmicsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    llista_amics = [];
    _loadFriends();
    //crida a backend per agafar tots els amics de l'usuari
    display_list = List.from(llista_amics);
  }

  String value = '';

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista(cercador)
    setState(
      () {
        display_list = llista_amics
            .where((element) =>
                element.nom.toLowerCase().contains(value.toLowerCase()))
            .toList();
      },
    );
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

    setState(() {
      display_list = List.from(llista_amics);
    });
  }

  Future<String> agafarLastMessage(Usuari amic) async {
    String msg = await _controladorPresentacion.lastMsg(amic.nom);
    return msg;
  }

  Future<String> agafarTimeLastMessage(Usuari amic) async {
    String time = await _controladorPresentacion.lasTime(amic.nom);
    return convertTimeFormat(time);
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
        color: grisFluix,
        height: 470.0,
        child: ListView.builder(
          itemCount: display_list.length,
          itemBuilder: (context, index) => _buildAmic(context, index),
        ),
      )
    ]);
  }

  Widget _buildCercador() {
    return TextField(
      onChanged: (value) => updateList(value),
      cursorColor: Colors.white,
      cursorHeight: 20,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(240, 186, 132, 1),
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
    );
  }

  Future<String>? convertToNullableFutureString(String? inputString) {
    if (inputString != null) {
      // Simulate an asynchronous operation with a delay of 0 milliseconds
      return Future.delayed(Duration.zero, () => inputString);
    } else {
      return null;
    }
  }

  Widget _buildAmic(context, index) {
    //crida per getUsuari

    return GestureDetector(
      onTap: () {
        //anar cap a la pantalla de un xat amb l'usuari
        //crida al backend per agafar el xat del amic en concret
        _controladorPresentacion.getXat(display_list[index].nom);
        _controladorPresentacion.mostrarXatAmic(context, display_list[index]);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image(
          //image: AssetImage(display_list[index].image),
          image: AssetImage(mockImage),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(display_list[index].nom,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            )),
        subtitle: FutureBuilder<String>(
          future: agafarLastMessage(display_list[index]),
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
        trailing: FutureBuilder<String>(
          future: agafarTimeLastMessage(display_list[index]),
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
    );
  }
}
