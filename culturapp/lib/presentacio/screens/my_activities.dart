import "package:culturapp/domain/models/actividad.dart";
//import "package:culturapp/presentacio/routes/routes.dart";
import "package:culturapp/presentacio/screens/search_my_activities.dart";
import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";

class MyActivities extends StatefulWidget {
  const MyActivities({super.key});

  @override
  State<MyActivities> createState() => _MyActivities();
}

class _MyActivities extends State<MyActivities> {
  //List<Actividad> activitats = null; quan tinguem de base de dades fer-ho bé

  void _onTabChange(int index) {
    switch (index) {
      case 0:
        //Navigator.pushNamed(context, '/');
        break;
      case 1:
        //Navigator.pushNamed(context, Routes.misActividades);
        break;
      case 2:
        //Navigator.pushNamed(context, Routes.xats);
        break;
      case 3:
        //Navigator.pushNamed(context, Routes.perfil);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: const Text(
            'Mis Actividades',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/myActivities/search');
                },
                icon: const Icon(Icons.search, color: Colors.white)),
          ]),
      body: const Center(
        child: Text('content: ficar activitats aquí'),
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
            GButton(
                text: "Mapa",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.map),
            GButton(
                text: "Mis Actividades",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.event),
            GButton(
                text: "Chats",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.chat),
            GButton(
                text: "Perfil",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.person),
          ],
        ),
      ),
    );
  }
}
