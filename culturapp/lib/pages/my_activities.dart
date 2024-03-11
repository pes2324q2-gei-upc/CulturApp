import "package:culturapp/models/cercador_my_activities.dart";
import "package:flutter/material.dart";

class MyActivities extends StatefulWidget {
  const MyActivities({super.key});

  @override
  State<MyActivities> createState() => _MyActivities();
}

class _MyActivities extends State<MyActivities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            'Mis Actividades',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CercadorMyActivities(),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white)),
          ]),
      body: const Center(
        child: Text('content: ficar activitats aquí'),
      ),
    );
  }
}
