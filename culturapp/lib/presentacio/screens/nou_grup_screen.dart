import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class NouGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const NouGrupScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<NouGrupScreen> createState() =>
      _NouGrupScreen(this.controladorPresentacion);
}

class _NouGrupScreen extends State<NouGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;

  _NouGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Crear Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          const SizedBox(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Escolleix els participants del nou grup: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                )),
          ),
          _buildCercadorBlanc(),
        ],
      ),
    );
  }

  Widget _buildCercadorBlanc() {
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
        ));
  }
}
