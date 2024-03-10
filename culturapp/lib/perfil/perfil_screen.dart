import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:culturapp/routes/routes.dart';


class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {

    super.initState();
  }
  
  void _onTabChange(int index) {
    switch (index) {
      case 0:
       Navigator.pushNamed(context, Routes.map);
      break;
      case 1:
        break;
      case 2:
        
        break;
      case 3:
        Navigator.pushNamed(context, Routes.perfil);
        break;
      default:
        break;
    }
  }


  //Se crea la ''pantalla'' para el
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
      child: GNav(
        backgroundColor: Colors.white,
        color: Colors.orange,
        activeColor: Colors.orange,
        tabBackgroundColor: Colors.grey.shade100,
        gap: 6,
        onTabChange: (index) {
          _onTabChange(index);
        },
        selectedIndex: 3,
        tabs: const [
          GButton(text: "Mapa", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.map),
          GButton(text: "Mis Actividades", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.event),
          GButton(text: "Chats", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.chat),
          GButton(text: "Perfil", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.person),
        ],
      ),
    ),
    );
  }
}