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
          title: const Text('MyActivities'),
        ),
        body: const Center(
          child: Text('MyActivities'),
        ));
  }
}
