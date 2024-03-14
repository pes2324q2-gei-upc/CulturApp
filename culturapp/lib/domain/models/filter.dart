import "package:culturapp/domain/models/actividad.dart";
import "package:flutter/material.dart";

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String _dropdownValue = 'concert';

  var _categories = ['concert', 'teatre', 'infantil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          width: 150,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: DropdownButton(
              items: _categories.map((String item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownValue = newValue!;
                });
              },
              value: _dropdownValue,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 50,
              style: const TextStyle(fontSize: 30, color: Colors.black),
              underline: Container(),
            ),
          )),
    ));
  }
}
//i have to limit the layout beacause : RenderPhysicalModel object was given an infinite size during layout.
//o el de search, sino no sortirà