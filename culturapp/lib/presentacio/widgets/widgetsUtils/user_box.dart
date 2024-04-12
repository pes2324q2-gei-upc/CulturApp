import 'package:flutter/material.dart';

class userBox extends StatelessWidget {
  final String text;

  const userBox({super.key, required this.text});

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
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: const Icon(
              Icons.image,
              color: Colors.white,
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
          const SizedBox(width: 8.0),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            /*child: Image.asset(
              'assets/categoriarecomm.png',
              fit: BoxFit.cover,
            ), Imagen para recomendador */
          ),
        ],
      ),
    );
  }
}
