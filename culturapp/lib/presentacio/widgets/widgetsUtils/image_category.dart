import 'package:flutter/material.dart';

class ImageCategory extends StatelessWidget {
  final String categoria;

  const ImageCategory({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getImageWidget(),
    );
  }

  Widget _getImageWidget() {
    switch (categoria) {
      case 'art':
        return Image.asset('assets/pinarte.png');
      case 'carnavals':
        return Image.asset('assets/pincarnaval.png');
      case 'circ':
        return Image.asset('assets/pincirc.png');
      case 'commemoracions':
        return Image.asset('assets/pincommemoracio.png');
      case 'concerts':
        return Image.asset('assets/pinconcert.png');
      case 'conferencies':
        return Image.asset('assets/pinconfe.png');
      case 'exposicions':
        return Image.asset('assets/pinexpo.png');
      case 'festes':
        return Image.asset('assets/pinfesta.png');
      case 'infantil':
        return Image.asset('assets/pininfantil.png');
      case 'recomanat':
        return Image.asset('assets/pinrecom.png');
      case 'rutes-i-visites':
        return Image.asset('assets/pinruta.png');
      case 'teatre':
        return Image.asset('assets/pinteatre.png');
      case 'activitats-virtuals':
        return Image.asset('assets/pinvirtual.png');
      default:
        // If no asset matches, return a default image or null
        return Container();
    }
  }
}