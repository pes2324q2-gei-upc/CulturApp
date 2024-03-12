
import 'package:culturapp/presentacio/widgets/user_info.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //no se que es esta funcuion
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
        //Navigator.pushNamed(context, Routes.actividades);
      break;
      case 2:
        //Navigator.pushNamed(context, Routes.chat);
      break;
      case 3:
        Navigator.pushNamed(context, Routes.perfil);
      break;
      default:
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
        children: [
          UserInfoWidget(), 
          MaterialButton(
          color: Colors.red,
          child: const Text("Sign out"),
          onPressed: () => signout(context))// Calling the UserInfoWidget
        ],
      ),
    //container amb les diferents pantalles
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

  void signout(context) {
    _auth.signOut();
    Navigator.pushNamed(context, Routes.login); // Cierra la llamada a MaterialPageRoute
  }
}

