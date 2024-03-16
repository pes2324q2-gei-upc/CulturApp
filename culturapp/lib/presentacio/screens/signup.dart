import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:sign_in_button/sign_in_button.dart";
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/routes/routes.dart';
import "package:culturapp/presentacio/controlador_presentacion.dart";
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Signup extends StatefulWidget {
  final User? user;

  const Signup({Key? key, this.user}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  List<String> selectedCategories = [];

  final List<String> _categories = [
    'carnavals',
    'teatre',
    'concerts',
    'circ',
    'exposicions',
    'commemoracions',
    'rutes-i-visites',
    'cursos',
    'activitats-virtuals',
    'infantil',
    'festes',
    'festivals-i-mostres',
    'dansa',
    'cicles',
    'cultura-digital',
    'fires-i-mercats',
    'gegants',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _signupScreen(context),
    );
  }

  Widget _signupScreen(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Nom d'usuari",
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return Color.fromARGB(244, 255, 145, 0).withOpacity(0.1);
                          },
                        ),
                        shadowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return Colors.transparent;
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0), // Ajusta el radio de los bordes aquí
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 20, horizontal: 15)),
                        alignment: Alignment.centerLeft
                      ),
                      onPressed: _showMultiSelect,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[800],),
                      label: Text("Categories preferides", style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
                    ),
                  )

                  ,
                  
                  SizedBox(height: 20),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      String username = usernameController.text;
                      createUser(username);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(
                            controladorPresentacion: ControladorPresentacion(),
                          ),
                        ),
                      );
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
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void createUser(String username) {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    usersCollection.doc(widget.user?.uid).set({
      'email': widget.user?.email,
      'username': username,
      'favcategories': selectedCategories,
    });
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: MultiSelectDialogField(
            items: _categories
                .map((animal) => MultiSelectItem<String>(animal, animal))
                .toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              setState(() {
                selectedCategories = values;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showMultiSelect() async {
    await showDialog(
      context: context,
      builder: (contex) {
        return  MultiSelectDialog(
          items: _categories
                .map((categoria) => MultiSelectItem<String>(categoria, categoria))
                .toList(),
          listType: MultiSelectListType.CHIP,
          initialValue: selectedCategories,
          onConfirm: (values) {
            selectedCategories = values;
          },
          selectedColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
          checkColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
          unselectedColor: Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
