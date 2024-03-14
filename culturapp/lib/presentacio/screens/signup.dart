import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:hive/hive.dart";
import "package:sign_in_button/sign_in_button.dart";
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/routes/routes.dart';

class Signup extends StatelessWidget {

  //Usuari de Firebase
  User? _user;

  //Instancia de autentificacio de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Constructora
  Signup(this._user);

  //Camps del formulari
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController atribut1Controller = TextEditingController();
  final TextEditingController atribut2Controller = TextEditingController();
  final TextEditingController atribut3Controller = TextEditingController();

  //Construir pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _signupScreen(context)
      );
  }

  //Pantalla de signup
  @override
  Widget _signupScreen(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),

                    const Text(
                      "Crear compte",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Afegeix la teva informació",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: atribut1Controller,
                      decoration: InputDecoration(
                          hintText: "Atribut1",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email)),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: atribut2Controller,
                      decoration: InputDecoration(
                        hintText: "Atribut2",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: atribut3Controller,
                      decoration: InputDecoration(
                        hintText: "Atribut3",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),

                    child: ElevatedButton(
                      onPressed: () {
                        String username = usernameController.text;
                        String atribut1 = atribut1Controller.text;
                        String atribut2 = atribut2Controller.text;
                        String atribut3 = atribut3Controller.text;
                        createUser(username, atribut1, atribut2, atribut3);
                        Navigator.pushNamed(context, Routes.perfil);
                      },
                      child: const Text(
                        "Crear compte",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color.fromARGB(244, 255, 145, 0),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Crear usuari a partir de les dades introduides i el compte de google
  void createUser(String username, String atribut1, String atribut2, String atribut3) {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  usersCollection.doc(_user?.uid).set({
    'email': _user?.email,
    'username': username,
  });
}
}