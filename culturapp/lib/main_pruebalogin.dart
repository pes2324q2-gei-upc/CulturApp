import 'package:culturapp/pages/login.dart';
import 'package:culturapp/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: Routes.login,
      routes: appRoutes,
    );
  }
}