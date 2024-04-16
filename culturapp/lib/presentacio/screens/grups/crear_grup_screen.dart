import "package:culturapp/presentacio/controlador_presentacio.dart";
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
  bool afegit = false;
  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _CrearGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  static List<String> amics = [
    'user1',
    'user2',
    'user3',
    'user4',
    'user5',
    'user6',
    'user7',
    'user8',
    'user9',
    'user10',
    'user11',
  ];

  /*
  si es fes un model per els participants dels grups hauria de tindre els atributs següents:
  -nom
  -foto
  (aquests dos es podrien agafar dels usuaris)
  - bool de si han sigut afegits
  */

  List<String> participants = ['usuaris  afegits'];

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {},
    );
  }

  void afegirParticipant(participant) {
    participants.add(participant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
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
                    ),
                  ),
                ),
                _buildCercador(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        'Afegits: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    /*Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.blue,
                    width: 320.0,
                    child: SizedBox(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: amics.length,
                        itemBuilder: (context, index) =>
                            _buildParticipantAfegit(context, index),
                      ),
                    ),
                  ),*/
                    //un altre element que seria el dels noms dels participants una vegada ficats dins
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  height: 500.0,
                  child: ListView.builder(
                    itemCount: amics.length,
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
            hintText: "Search...",
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            suffixIcon: const Icon(Icons.search),
            suffixIconColor: Colors.white,
          ),
        ));
  }

  /*Widget _buildParticipantAfegit(context, index) {
    return ListTile(
      title: Text(
        amics[index],
        //participants[index],
      ),
    );
  }*/

  Widget _buildParticipant(context, index) {
    return ListTile(
      //una vegada tingui mes info del model
      //dels perfils lo seu seria canviar-ho
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image.network(
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
      title: Text(amics[index],
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          )),
      trailing: _buildBotoAfegir(amics[index]),
    );
  }

  Widget _buildBotoAfegir(participant) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        afegit = !afegit;
        afegirParticipant(participant);
      },
      child: Text(
        afegit ? '-' : '+',
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
        _controladorPresentacion.mostrarConfigGrup(context);
      },
    );
  }
}
