import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

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
  bool afegit = false;
  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _NouGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  static List<String> mockParticipants = [
    'user1',
    'user2',
  ];

  /*
  si es fes un model per els participants dels grups hauria de tindre els atributs següents:
  -nom
  -foto
  (aquests dos es podrien agafar dels usuaris)
  - bool de si han sigut afegits
  */

  List<String> participantsAfegits = ['usuaris  afegits'];

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {},
    );
  }

  void afegirParticipant(participant) {
    participantsAfegits.add(participant);
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
      body: Stack(
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
                    padding: EdgeInsets.all(10.0),
                    child: Text(
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
                        itemCount: mockParticipants.length,
                        itemBuilder: (context, index) =>
                            _buildParticipantAfegit(context, index),
                      ),
                    ),
                  ),*/
                  //un altre element que seria el dels noms dels participants una vegada ficats dins
                ],
              ),
              SizedBox(
                height: 420.0,
                child: ListView.builder(
                  itemCount: mockParticipants.length,
                  itemBuilder: (context, index) =>
                      _buildParticipant(context, index),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: _buildNextPageButton(),
          ),
        ],
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
        mockParticipants[index],
        //participantsAfegits[index],
      ),
    );
  }*/

  Widget _buildParticipant(context, index) {
    return ListTile(
      //una vegada tingui mes info del model
      //dels perfils lo seu seria canviar-ho
      contentPadding: EdgeInsets.all(8.0),
      leading: Image.network(
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
      title: Text(mockParticipants[index],
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          )),
      trailing: _buildBotoAfegir(mockParticipants[index]),
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
