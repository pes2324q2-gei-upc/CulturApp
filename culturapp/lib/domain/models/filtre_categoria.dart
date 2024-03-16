import "package:culturapp/domain/models/actividad.dart";
import "package:flutter/material.dart";

class FiltreCategoria extends StatefulWidget {
  const FiltreCategoria(
      {super.key, required Null Function(dynamic newFilter) canviCategoria});

  @override
  _FiltreState createState() => _FiltreState();
}

class _FiltreState extends State<FiltreCategoria> {
  static const List<String> llistaCategories = <String>[
    'concert',
    'infantil',
    'teatre'
  ];
  late String _selectedCategory = llistaCategories.first;
  //categoria seleccionada

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _selectedCategory = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.centerLeft,
      child: Container(
          width: 90,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 2.0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: llistaCategories.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: dropdownCallback,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              underline: Container(),
            ),
          )),
    ));
  }
}
