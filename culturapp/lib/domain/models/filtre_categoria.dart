/*import "package:culturapp/domain/models/actividad.dart";
import "package:flutter/material.dart";

class FiltreCategoria extends StatefulWidget {
  final String categoria;
  const FiltreCategoria({super.key, required String categoria});

  @override
  _FiltreState createState() => _FiltreState(categoria);
}

class _FiltreState extends State<FiltreCategoria> {
  late String _categoria = ;

  _FilterState(String categoria) {
    llistaCategories = //funcio crida backend que retorna totes les categories or smth
        _categoria = llistaCategories.first;
  }

  static const List<String> llistaCategories = <String>[
    'concert',
    'infantil',
    'teatre'
    //agar tots els tipus
  ];

  void categoriaCanviada(String? selectedValue) {
    //el string ha de ser igual a la categoria clicada
    if (selectedValue is String) {
      setState(() {
        _categoria = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
      alignment: Alignment.centerLeft,
      child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 170, 102, 0.5),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: llistaCategories.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: categoriaCanviada,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: Color.fromRGBO(255, 170, 102, 0.5),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              iconSize: 20,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              underline: Container(),
            ),
          )),
    ));
  }
}
*/