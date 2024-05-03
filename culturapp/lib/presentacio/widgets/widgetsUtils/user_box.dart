import 'dart:convert';

import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class userBox extends StatefulWidget {
  final String text;
  final bool recomm;
  final String type;
  final ControladorPresentacion controladorPresentacion;
  const userBox({super.key, required this.text, required this.recomm, required this.type, required this.controladorPresentacion,});

  @override
  State<userBox> createState() => _userBoxState();
}

class _userBoxState extends State<userBox> {
  bool _showButtons = true;
  String _action = "";

  void _handleButtonPress(String action, String text) {
    if (action == "accept") {
      widget.controladorPresentacion.acceptFriend(text);
    } else if (action == "delete") {
      widget.controladorPresentacion.deleteFriend(text);
    } else if (action == "create") {
      widget.controladorPresentacion.createFriend(text);
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
                  _handleButtonPress("delete", widget.text);
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
                  _handleButtonPress("accept", widget.text);
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
                        _handleButtonPress("create", widget.text);
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
