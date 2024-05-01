import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userBox extends StatelessWidget {
  final String text;
  final bool recomm;
  final String type;
  final String token;
  const userBox({super.key, required this.text, required this.recomm, required this.type, required this.token});

  Future<void> actionUser(String token, String action, String person) async {

    final respuesta = await http.get(
      Uri.parse('http://10.0.2.2:8080/amics/$action/$person'),
      headers: {
      'Authorization': 'Bearer $token',
      },
    );

    if (respuesta.statusCode != 200) throw Exception('Error al aceptar al usuario');
  }


  Future<void> acceptUser(String token, String action, String person) async {
    return actionUser(token, action, person);
  }

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10.0), // Borde superior redondeado
        bottom: Radius.circular(10.0), // Borde inferior redondeado
      ),
      color: Colors.grey[100], // Cambia el color de fondo según necesites
    ),
    child: Row(
      children: [
        if (recomm)
          Column( // Envuelve el bloque if con un widget Column
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/categoriarecom.png',
                  fit: BoxFit.fill,
                ), //Imagen para recomendador */
              ),
            ],
          ),
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Image.asset(
            'assets/userImage.png', 
            fit: BoxFit.cover, 
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
Row(
  children: [
    if(type == "pending") ...[
      SizedBox(
        width: 50,
        child: TextButton(
          onPressed: () {
            // Add your onPressed logic here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFAA80)),
          ),
          child: const Text('X', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
        ),
      ),
      const SizedBox(width: 8.0),
      SizedBox(
        width: 50,
        child: TextButton(
          onPressed: () {
            // Add your onPressed logic here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
          ),
          child: const Text('✓', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
        ),
      ),
    ] else if (type == "addSomeone") ...[
      const SizedBox(width: 8.0),
      SizedBox(
        width: 50,
        child: TextButton(
          onPressed: () {
            // Add your onPressed logic here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
          ),
          child: const Text('+', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
        ),
      ),
    ] else if(type == "deleteFollow") ...[
      const SizedBox(width: 8.0),
      SizedBox(
        width: 50,
        child: TextButton(
          onPressed: () {
            // Add your onPressed logic here
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFAA80)),
          ),
          child: const Text('-', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
        ),
      ),
    ]
    ],
),

      ],
    ),
  );
}
}
