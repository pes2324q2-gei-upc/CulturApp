import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userBox extends StatefulWidget {
  final String text;
  final bool recomm;
  final String type;
  final String token;
  const userBox({super.key, required this.text, required this.recomm, required this.type, required this.token});

  @override
  State<userBox> createState() => _userBoxState();
}

class _userBoxState extends State<userBox> {
  bool _showButtons = true;
  String _action = "";

  Future<void> acceptFriend(String token, String person) async {
    final http.Response response = await http.put(
      Uri.parse('http://10.0.2.2:8080/amics/accept/$person'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al aceptar al usuario');
  }

  Future<void> deleteFriend(String token, String person) async {
    final http.Response response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/amics/delete/$person'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
  }

  Future<void> createFriend(String token, String person) async {
    final Map<String, dynamic> body = {
        'friend': person,
      };

    final http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8080/amics/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print(response.body);

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
  }

  void _handleButtonPress(String token, String action, String text) {
    if (action == "accept") {
      acceptFriend(token, text);
    } else if (action == "delete") {
      deleteFriend(token, text);
    } else if (action == "create") {
      createFriend(token, text);
    }

    setState(() {
      _showButtons = false;
    });
  }

  Widget _buildActionButtons() {
      if (_showButtons) {
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: TextButton(
                onPressed: () {
                  _action = "rechazada";
                  _handleButtonPress(widget.token, "delete", widget.text);
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
                  _action = "aceptada";
                  _handleButtonPress(widget.token, "accept", widget.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
                ),
                child: const Text('✓', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ],
        );
      } else {
        return Text("Solicitud $_action"); //Falta idioma
      }
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
          if (widget.recomm)
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
              widget.text,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Row(
            children: [
              if(widget.type == "pending") ...[
                _buildActionButtons(),
              ] else if(widget.type == "addSomeone") ...[
                if (_showButtons) ...[
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: 50,
                    child: TextButton(
                      onPressed: () {
                        _action = "enviada";
                        _handleButtonPress(widget.token, "create", widget.text);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFF4692A)),
                      ),
                      child: const Text('+', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                  ),
                ] else ...[
                  Text("Solicitud $_action"), //Falta idioma
                ] 
              ]
            ],
          ),
        ],
      ),
    );
  }
}
