import "package:culturapp/domain/converters/convert_date_format.dart";
import "package:culturapp/domain/converters/truncar_string.dart";
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

  Future<void> _initialize() async {
    List<Grup> grups = await _controladorPresentacion.getUserGrups();
    if (mounted) {
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
              width: 5.0,
            ),
            Flexible(child: _buildCercador()),
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
          height: 470.0,
          child: RefreshIndicator(
            onRefresh: _initialize,
            child: ListView.builder(
              itemCount: display_list.length,
              itemBuilder: (context, index) => _buildGrupItem(context, index),
            ),
          ),
        ),
      ],
    );
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

  Widget _buildNewGroupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Color(0xFFF4692A),
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
        leading: SizedBox(
          width: 50,
          height: 50,
          child: display_list[index].imageGroup.isNotEmpty
              ? ClipOval(
                  child: Image(
                    image: NetworkImage(display_list[index].imageGroup),
                    fit: BoxFit.cover,
                  ),
                )
              : const Image(
                  image: AssetImage('assets/userImage.png'),
                ), // Placeholder widget to show if there's no image
        ),
        title: Text(truncarString(display_list[index].nomGroup, 22),
            style: TextStyle(
              color: taronjaVermellos,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(truncarString(display_list[index].lastMessage, 24)),
        trailing: Text(convertTimeFormat(display_list[index].timeLastMessage)),
      ),
    );
  }
}
