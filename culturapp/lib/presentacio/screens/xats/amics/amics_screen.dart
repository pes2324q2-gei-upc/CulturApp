import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
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
  late List<String> llista_amics;
  late List<String> display_list;

  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  String mockImage = 'assets/userImage.png';
  String mockLastMessage = 'mock';
  String mockTimeMessage = '00:00';

  _AmicsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    //llista_amics =
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
                element.toLowerCase().contains(value.toLowerCase()))
            .toList();
      },
    );
  }

  Future<void> _loadFriends() async {
    llista_amics = await _controladorPresentacion.obteAmics();
    /*setState(() {
      messages = convertData(loadedMessages).reversed.toList();
    });*/
  }

  Future<String> agafarLastMessage(Usuari amic) async {
    String msg = await _controladorPresentacion.lastMsg(amic.id);
    return msg;
  }

  Future<String> agafarTimeLastMessage(Usuari amic) async {
    String time = await _controladorPresentacion.lasTime(amic.id);
    return time;
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
        hintText: "Search...",
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
        //_controladorPresentacion.getXat(display_list[index].nom);
        _controladorPresentacion
            .getXat("Eman"); //quan obtingui followers, treure

        //_controladorPresentacion.mostrarXatAmic(context, display_list[index]);
        _controladorPresentacion.mostrarXatAmic(context, mockUsuari);
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
        title: Text(display_list[index],
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            )),
        subtitle: FutureBuilder<String>(
          future: convertToNullableFutureString(
              mockLastMessage), //agafarLastMessage(display_list[index]),
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
        //Text(agafarLastMessage(display_list[index])),
        trailing: FutureBuilder<String>(
          future: convertToNullableFutureString(
              mockTimeMessage), //agafarTimeLastMessage(display_list[index]),
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
        //Text(agafarTimeLastMessage(display_list[index]),),
      ),
    );
  }
}
