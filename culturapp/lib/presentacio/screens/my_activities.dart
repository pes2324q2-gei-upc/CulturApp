import "package:culturapp/translations/AppLocalizations";
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
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF4692A),
          title: Text(
            'my_activities'.tr(context),
            style: const TextStyle(color: Colors.white),
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
