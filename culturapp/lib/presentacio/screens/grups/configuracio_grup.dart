import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class ConfigGrup extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const ConfigGrup({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<ConfigGrup> createState() => _ConfigGrup(this.controladorPresentacion);
}

class _ConfigGrup extends State<ConfigGrup> {
  late ControladorPresentacion _controladorPresentacion;
  bool afegit = false;
  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _ConfigGrup(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  void assignarNomGrup(String value) {
    //ficar valor a "nom" de Grup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Configuració Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Imatge (opcional):',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Image.network(
                    'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
                    //cambiar imatge this one is pochilla
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Nom del grup: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                TextField(
                  onChanged: (value) => assignarNomGrup(value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Nom del grup...",
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    suffixIcon: const Icon(Icons.search),
                    suffixIconColor: Colors.white,
                  ),
                ),
              ],
            ),
            Text('hello'),
          ],
        ),
      ),
    );
  }
}
