import 'package:flutter/material.dart';

class MyCarousel extends StatelessWidget {

  final Function(String) clickCarouselCat; // Callback function

  MyCarousel(this.clickCarouselCat); // Constructor to receive the callback

  @override
  Widget build(BuildContext context) {
    List<Widget> carouselItems = [
      _buildCarouselItem(context, 'Festa', 'festes'),
      _buildCarouselItem(context, 'Infantil', 'infantil'),
      _buildCarouselItem(context, 'Circ', 'circ'),
      _buildCarouselItem(context, 'Commemoracio', 'commemoracions'),
      _buildCarouselItem(context, 'Exposicions', 'exposicions'),
      _buildCarouselItem(context, 'Art', ''),
      _buildCarouselItem(context, 'Carnaval', 'carnavals'),
      _buildCarouselItem(context, 'Concerts', 'concerts'),
      _buildCarouselItem(context, 'Conferencies', 'conferencies'),
      _buildCarouselItem(context, 'Rutes', 'rutes-i-visites'),
      _buildCarouselItem(context, 'Activitats Virtuals', 'activitats-virtuals'),
      _buildCarouselItem(context, 'Teatre', 'teatre'),
    ];

    return Row(
      children: [ 
        Expanded(child: Center(
            child: Container(
              height: 80, // specify the height you want here
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
            width: 45.0,
          );
    }
    else {
      switch (categoria) {
        case 'carnavals':
          return Image.asset(
            'assets/categoriacarnaval.png',
            width: 45.0,
          );
        case 'teatre':
          return Image.asset(
            'assets/categoriateatre.png',
            width: 45.0,
          );
        case 'concerts':
          return Image.asset(
            'assets/categoriaconcert.png',
            width: 45.0,
          );
        case 'circ':
          return Image.asset(
            'assets/categoriacirc.png',
            width: 45.0,
          );
        case 'exposicions':
          return Image.asset(
            'assets/categoriaarte.png',
            width: 45.0,
          );
        case 'conferencies':
          return Image.asset(
            'assets/categoriaconfe.png',
            width: 45.0,
          );
        case 'commemoracions':
          return Image.asset(
            'assets/categoriacommemoracio.png',
            width: 45.0,
          );
        case 'rutes-i-visites':
          return Image.asset(
            'assets/categoriaruta.png',
            width: 45.0,
          );
        case 'cursos':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'activitats-virtuals':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'infantil':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'festes':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'festivals-i-mostres':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'dansa':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'cicles':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'cultura-digital':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'fires-i-mercats':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'gegants':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        default:
          return Image.asset(
            'assets/categoriarecom.png',
            width: 45.0,
          );
      }
    }
  }

  Widget _buildCarouselItem(BuildContext context, String label, String iconName) {
  return Padding(
    padding: EdgeInsets.all(5.0), // Add padding between items
    child: GestureDetector(
      onTap: () {
        clickCarouselCat(label);
      },
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _retornaIcon(iconName),
                    SizedBox(width: 8), // Adjust the spacing between icon and text as needed
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
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
      ),
    );
  }

}