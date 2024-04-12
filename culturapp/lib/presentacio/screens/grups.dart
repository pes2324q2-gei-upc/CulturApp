import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class Grups extends StatefulWidget {
  @override
  State<Grups> createState() => _GrupsState();
}

class _GrupsState extends State<Grups> {
  static List<String> llista_grups = [
    'grup1',
    'concerts_grups',
    'maira',
    'marta',
    'laia',
    'felip',
    'marc'
  ]; //eventualment substituir-ho per crida a backend o el q sigui

  List<String> display_list = List.from(llista_grups);

  String value = '';

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {
        display_list = llista_grups
            .where((element) =>
                element.toLowerCase().contains(value.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildCercador(),
      const SizedBox(
        height: 20.0,
      ),
      SizedBox(
        height: 420.0,
        child: ListView.builder(
          itemCount: display_list.length,
          itemBuilder: (context, index) => ListTile(
              //una vegada tingui mes info del model
              //dels perfils lo seu seria canviar-ho
              contentPadding: EdgeInsets.all(8.0),
              title: Text(display_list[index],
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      )
    ]);
  }

  Widget _buildCercador() {
    return SizedBox(
        height: 40.0,
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
