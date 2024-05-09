import 'package:flutter/material.dart';

class MyCarousel extends StatefulWidget {
  final Function(String) clickCarouselCat; // Callback function

  MyCarousel(this.clickCarouselCat); // Constructor to receive the callback

  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      _buildCarouselItem(context, 'Festa', 'festes', 0),
      _buildCarouselItem(context, 'Infantil', 'infantil', 1),
      _buildCarouselItem(context, 'Circ', 'circ', 2),
      _buildCarouselItem(context, 'Commemoracio', 'commemoracions', 3),
      _buildCarouselItem(context, 'Art', 'exposicions', 4),
      _buildCarouselItem(context, 'Carnaval', 'carnavals', 6),
      _buildCarouselItem(context, 'Concerts', 'concerts', 7),
      _buildCarouselItem(context, 'Conferencies', 'conferencies', 8),
      _buildCarouselItem(context, 'Rutes', 'rutes-i-visites', 9),
      _buildCarouselItem(context, 'Activitats Virtuals', 'activitats-virtuals', 10),
      _buildCarouselItem(context, 'Teatre', 'teatre', 11),
    ];

    return Row(
      children: [ 
        Expanded(child: Center(
            child: Container(
              height: 60, // specify the height you want here
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: carouselItems.length,
                itemBuilder: (context, index) {
                  return carouselItems[index];
                },
              ),
            ),
          ),
        )
      ]
    );
  }

  final List<String> catsAMB = ["Residus",
  "territori.espai_public_platges",
  "Sostenibilitat",
  "Aigua",
  "territori.espai_public_parcs",
  "Espai públic - Rius",
  "Espai públic - Parcs",
  "Portal de transparència",
  "Mobilitat sostenible",
  "Internacional",
  "Activitat econòmica",
  "Polítiques socials",
  "territori.espai_public_rius",
  "Espai públic - Platges"];

Image _retornaIcon(String categoria) {
    if (catsAMB.contains(categoria)){
      return Image.asset(
            'assets/categoriareciclar.png',
            width: 30.0,
          );
    }
    else {
      switch (categoria) {
        case 'carnavals':
          return Image.asset(
            'assets/categoriacarnaval.png',
            width: 30.0,
          );
        case 'teatre':
          return Image.asset(
            'assets/categoriateatre.png',
            width: 30.0,
          );
        case 'art':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'concerts':
          return Image.asset(
            'assets/categoriaconcert.png',
            width: 30.0,
          );
        case 'circ':
          return Image.asset(
            'assets/categoriacirc.png',
            width: 30.0,
          );
        case 'exposicions':
          return Image.asset(
            'assets/categoriaarte.png',
            width: 30.0,
          );
        case 'conferencies':
          return Image.asset(
            'assets/categoriaconfe.png',
            width: 30.0,
          );
        case 'commemoracions':
          return Image.asset(
            'assets/categoriacommemoracio.png',
            width: 30.0,
          );
        case 'rutes-i-visites':
          return Image.asset(
            'assets/categoriaruta.png',
            width: 30.0,
          );
        case 'cursos':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 30.0,
          );
        case 'activitats-virtuals':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 30.0,
          );
        case 'infantil':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 30.0,
          );
        case 'festes':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 30.0,
          );
        case 'festivals-i-mostres':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 30.0,
          );
        case 'dansa':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 30.0,
          );
        case 'cicles':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 30.0,
          );
        case 'cultura-digital':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 30.0,
          );
        case 'fires-i-mercats':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 30.0,
          );
        case 'gegants':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 30.0,
          );
        default:
          return Image.asset(
            'assets/categoriarecom.png',
            width: 30.0,
          );
      }
    }
  }

Widget _buildCarouselItem(BuildContext context, String label, String iconName, int index) {
  return Padding(
    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 7.0, bottom: 7.0), // Agregar padding entre elementos
    child: GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndices.contains(index)) {
            selectedIndices.remove(index);
          } else {
            selectedIndices.add(index);
          }
        });
        widget.clickCarouselCat(iconName);
      },
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: .0),
          decoration: BoxDecoration(
                color: selectedIndices.contains(index) ? Colors.orange.withOpacity(1) : Colors.white.withOpacity(1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(25.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Ajustar la alineación vertical
                children: [
                  Column(
                    children: [SizedBox(height: 4), _retornaIcon(iconName),],
                    mainAxisAlignment: MainAxisAlignment.center,),
                    
                  SizedBox(width: 8), // Ajustar el espacio entre el icono y el texto según sea necesario
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: selectedIndices.contains(index) ? Colors.white : Color(0xFF333333)),
                    ),
                  ),
                  SizedBox(width: 8,)
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}