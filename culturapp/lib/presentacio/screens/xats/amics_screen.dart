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
  late List<Usuari> llista_amics;
  late List<Usuari> display_list;

  _AmicsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    llista_amics = allAmics;
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
      SizedBox(
        height: 420.0,
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

  Widget _buildAmic(context, index) {
    return GestureDetector(
      onTap: () {
        //anar cap a la pantalla de un xat amb l'usuari
        //crida al backend per agafar el xat del amic en concret
        _controladorPresentacion.mostrarXatAmic(context, display_list[index]);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image(
          image: AssetImage(display_list[index].image),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(display_list[index].nom,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(display_list[index].lastMessage),
        trailing: Text(
          display_list[index].timeLastMessage,
        ),
      ),
    );
  }
}
