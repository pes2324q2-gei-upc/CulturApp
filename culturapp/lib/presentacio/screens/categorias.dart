import 'package:flutter/material.dart';

class Categorias extends StatefulWidget {
  final List<String> selected;

  Categorias({Key? key, required this.selected}) : super(key: key);

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < categorias.length; i++) {
      if (widget.selected.contains(categorias[i])) {
        isSelected[i] = true;
        selectedCount++;
      }
    }
  }

  final List<String> imagenes = [
    'assets/festa.png',
    'assets/infantil.png',
    'assets/circ.png',
    'assets/commem.png',
    'assets/expo.png',
    'assets/art.png',
    'assets/carnav.png',
    'assets/concert.png',
    'assets/confe.png',
    'assets/ruta.png',
    'assets/virtual.png',
    'assets/teatr.png',
  ];

  final List<String> categorias = [
    'Festa',
    'Infantil',
    'Circ',
    'Commemoració',
    'Exposicions',
    'Art',
    'Carnaval',
    'Concerts',
    'Conferencies',
    'Rutes',
    'Activitats Virtuals',
    'Teatre',
  ];

  List<bool> isSelected = List.filled(12, false);

  int selectedCount = 0;

  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Escull categories",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF4692A)),
                ),
                Text(
                  "$selectedCount/3",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF4692A)),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: List.generate(12, (index) => _buildButton(index)),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: selectedCount == 3 ? _onFinalizar : null,
              child: Text(
                "Finalitzar",
                style: TextStyle(color: Color(0xFFF4692A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFinalizar() {
    List<String> selectedCategories = [];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        selectedCategories.add(categorias[i]);
      }
    }
    Navigator.pop(context, selectedCategories);
  }

  Widget _buildButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCount < 3 || isSelected[index]) {
            isSelected[index] = !isSelected[index];
            selectedCount = isSelected.where((item) => item).length;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected[index] ? Color(0xFFF4692A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagenes[index],
              height: 50.0,
            ),
            SizedBox(height: 5.0),
            Text(
              categorias[index],
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
