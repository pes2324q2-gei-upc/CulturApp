import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class GrupsScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const GrupsScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<GrupsScreen> createState() =>
      _GrupsScreenState(this.controladorPresentacion);
}

class _GrupsScreenState extends State<GrupsScreen> {
  late ControladorPresentacion _controladorPresentacion;

  _GrupsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  static List<Grup> llista_grups =
      allGroups; //eventualment substituir-ho per crida a backend o el q sigui

  List<Grup> display_list = allGroups; //llista_grups

  String value = '';

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {
        display_list = llista_grups
            .where((element) =>
                element.titleGroup.toLowerCase().contains(value.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildCercador(),
            const SizedBox(
              width: 5.0,
            ),
            _buildNewGroupButton(),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 420.0,
          child: ListView.builder(
            itemCount: display_list.length,
            itemBuilder: (context, index) => _buildGrupItem(context, index),
          ),
        ),
      ],
    );
  }

  Widget _buildCercador() {
    return SizedBox(
        height: 40.0,
        width: 250.0,
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

  Widget _buildNewGroupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        _controladorPresentacion.mostrarCrearNouGrup(context);
      },
      child: const Text('+'),
    );
  }

  Widget _buildGrupItem(context, index) {
    return GestureDetector(
      onTap: () {
        //anar cap a la pantalla de un xat
        _controladorPresentacion.mostrarXatGrup(context);
      },
      child: ListTile(
        //una vegada tingui mes info del model
        //dels perfils lo seu seria canviar-ho
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.network(
          display_list[index].imageGroup,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(display_list[index].titleGroup,
            style: const TextStyle(
              color: const Color(0xFFF4692A),
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
