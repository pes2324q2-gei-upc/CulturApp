import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/translations/AppLocalizations";
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
  late List<Grup> llista_grups;
  late List<Grup> display_list = [];
  String value = '';

  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);
  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);

  _GrupsScreenState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    _initialize();
  }

  void _initialize() async {
    List<Grup> grups = await _controladorPresentacion.getUserGrups();
    if(mounted){
      setState(() {
        llista_grups = grups;
        display_list = llista_grups;
      });
    }
  }

  void updateList(String value) {
    //funcio on es filtrarà els grups per nom (cercador)
    setState(
      () {
        display_list = llista_grups
            .where((element) =>
                element.nomGroup.toLowerCase().contains(value.toLowerCase()))
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
            const SizedBox(
              width: 10.0,
            ),
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
        Container(
          color: grisFluix,
          height: 470.0,
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
      width: 280.0,
      child: TextField(
        onChanged: (value) => updateList(value),
        cursorColor: Colors.white,
        cursorHeight: 20,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: taronjaVermellosFluix,
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
      ),
    );
  }

  Widget _buildNewGroupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: taronjaVermellosFluix,
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
        _controladorPresentacion.mostrarXatGrup(context, display_list[index]);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: const Image(
          //image: AssetImage(display_list[index].imageGroup),
          image: AssetImage('assets/userImage.png'),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(display_list[index].nomGroup,
            style: TextStyle(
              color: taronjaVermellos,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(display_list[index].lastMessage),
        trailing: Text(convertTimeFormat(display_list[index].timeLastMessage)),
      ),
    );
  }
}
