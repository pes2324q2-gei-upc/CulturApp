import 'package:flutter/material.dart';

class Categorias extends StatefulWidget {
  List<String>selected;
  
  Categorias({super.key, required this.selected});

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
  
  //asset dels icones
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
  // nom de cada categoria en el mateix ordre que la llista d'icones
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

  //tots començen estant sense seleccionar
  List<bool> isSelected = List.filled(12, false);

  int selectedCount = 0; // Contador de categories seleccionades


  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 35.0, left: 10.0),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                const Text(
                  "Escull categories",
                  style: TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold, color: const Color(0xFFF4692A)),
                ),
                Text(" $selectedCount/3",
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: const Color(0xFFF4692A))), // Contador
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Expanded( // Cambio de Flexible a Expanded
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0,), //Espai amb el text d'escollits
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                children: List.generate(12, (index) => _buildButton(index)),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10.0)),
          //Botó finalitzar que passa a estar actiu quan hi ha 3 seleccionades
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: selectedCount == 3 ? _onFinalizar : null,
              child: const Text("Finalitzar", style: TextStyle(color: const Color(0xFFF4692A) ),),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10.0)),
        ],
      ),
    );
  }

  //Guardar categories preferides a una llista
void _onFinalizar() {
  List<String> selectedCategories = [];
  for (int i = 0; i < isSelected.length; i++) {
    if (isSelected[i]) {
      selectedCategories.add(categorias[i]);
    }
  }
  Navigator.pop(context, selectedCategories); // Devuelve el resultado al cerrar la ventana
}

  //Funció pels botons de categoria
  Widget _buildButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCount < 3) {
            isSelected[index] = !isSelected[index];
            selectedCount = isSelected.where((item) => item == true).length;
          } else if (isSelected[index]) {
            isSelected[index] = false;
            selectedCount--;
          } else if (selectedCount == 3){
            if (isSelected[index]) {
            isSelected[index] = false;
            selectedCount--;
            }
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected[index] ? const Color(0xFFF4692A) : Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            Image.asset(
              imagenes[index],
              height: 50.0, 
            ),
            const Padding(padding: EdgeInsets.all(5.0),),
            Text(categorias[index] , style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}