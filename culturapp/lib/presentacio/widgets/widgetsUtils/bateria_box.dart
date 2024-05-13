import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool isStreetAddress(String address) {
  final regex = RegExp(r'[a-zA-Z]+\s+\d');
  return regex.hasMatch(address);
}
class bateriaBox extends StatelessWidget {
  final String adress;
  final int kw;
  final String speed;
  final double distancia;
  final double latitud;
  final double longitud;
  const bateriaBox({super.key, required this.adress, required this.kw, required this.speed, required this.distancia, required this.latitud, required this.longitud});

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10.0),
        bottom: Radius.circular(10.0),
      ),
      color: Colors.grey[100], // Cambia el color de fondo según necesites
    ),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(
            'assets/cargador.png', 
         fit: BoxFit.cover, 
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${distancia.toStringAsFixed(2)} Kms', // Distancia con 1 decimal
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$kw kW', // kW
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    if (speed == 'RAPID') ...[
                      Transform.translate(
                        offset: const Offset(0.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-12.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-24.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                    ]else if (speed == 'superRAPID') ...[
                      Transform.translate(
                        offset: const Offset(0.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-12.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-24.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-36.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                    ]else if (speed == 'semiRAPID') ...[
                      Transform.translate(
                        offset: const Offset(0.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                      Transform.translate(
                        offset: const Offset(-12.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                    ] else if (speed == 'NORMAL') ...[
                      Transform.translate(
                        offset: const Offset(0.0, 0.0),
                        child: const Icon(Icons.flash_on, color:  Color(0xFFF4692A),),
                      ),
                    ],
                  ],
                ),
                Text(
                  isStreetAddress(adress) ? adress : 'No disponible',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 7.5)),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 32.5, // Establece la altura del botón
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: Colors.black, 
                      ),
                      icon: const Icon(Icons.location_on),
                      label: const Text('Como llegar'),
                      onPressed: () async {
                        final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitud,$longitud');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'No se pudo abrir $url';
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}