import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  
  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String _selectedText = 'Historico actividades';

  @override
  Widget build(BuildContext context) {
    //faltaria adaptar el padding en % per a cualsevol dispositiu
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 55, bottom:20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/userImage.png',
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
                const SizedBox(width: 10),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'XP',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const Spacer(), 
                IconButton(
                  onPressed: () {
                    //hacer que me lleve a una nueva pestaña con las opciones de configuración
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            color: Colors.orange, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //historico actividades
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedText = 'Historico actividades';
                    });
                  },
                  icon: const Icon(Icons.event_available),
                  color: Colors.white,
                ),
                //insignias o logros
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedText = 'Lista insignias';
                    });
                  },
                  //icon: const Icon(Icons.redeem),
                  icon: const Icon(Icons.stars),
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _selectedText, // Display the selected text
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      );
  }
}