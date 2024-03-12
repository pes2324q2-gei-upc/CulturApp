import 'package:flutter/material.dart';

class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: const Text(
          "Categories Preferides",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Stack(
        children: <Widget>[
          //Imatge en diagonal pel background
          Container(
            height: size.height * 0.15,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              const Text(
                "Escull categories",
                style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(" $selectedCount/3",
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)), // Contador
            ],
          ),
        ),
        //definicio de l'espai per les categories
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(40.0), //Espai amb el text d'escollits
            child: GridView.count(
              // 2 per fila amb espai entre ells
              crossAxisCount: 2,
              mainAxisSpacing: 32.0,
              crossAxisSpacing: 32.0,
              children: List.generate(12, (index) => _buildButton(index)),
              ),
            ),
          ),
          //Botó finalitzar que passa a estar actiu quan hi ha 3 seleccionades
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: selectedCount == 3 ? _onFinalizar : null,
              child: const Text("Finalitzar", style: TextStyle(color: Colors.black),),
            ),
          ),
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
  }

  //Funció pels botons de categoria
  Widget _buildButton(int index) {
    return GestureDetector(
      //Quan es premi algun en funcio de quantes s'han escollit:
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
      //Disseny de les categories
      child: Container(
        decoration: BoxDecoration(
          //Seleccionat color taronja, si no gris
          color: isSelected[index] ? Colors.orange : Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        ),
        //Columna per tenir tant imatge com nom
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(12.0)),
            Image.asset(
              imagenes[index],
              height: 75.0,
              width: 75.0,
            ),
            const Padding(padding: EdgeInsets.all(5.0),),
            Text(categorias[index] , style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}