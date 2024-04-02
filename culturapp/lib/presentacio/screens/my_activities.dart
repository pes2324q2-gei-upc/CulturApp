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
    );
  }
}
