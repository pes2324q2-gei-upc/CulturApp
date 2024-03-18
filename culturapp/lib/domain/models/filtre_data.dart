import "package:flutter/material.dart";

//ensenyar activitats que comencen a partir de o més tard
//o maybe quin dia

class FiltreData extends StatefulWidget {
  const FiltreData(
      {super.key, required Null Function(dynamic newData) canviData});

  @override
  _FiltreState createState() => _FiltreState();
}

class _FiltreState extends State<FiltreData> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.center,
            child: Container(
                width: 500.0,
                child: TextField(
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    controller: _dateController,
                    decoration: const InputDecoration(
                        labelText: 'Data',
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        filled: true,
                        fillColor: Color.fromRGBO(255, 170, 102, 0.5),
                        prefixIcon: Icon(Icons.calendar_today,
                            size: 18, color: Colors.white),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange))),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    }))));
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
