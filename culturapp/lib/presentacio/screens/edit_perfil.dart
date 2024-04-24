import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditPerfil extends StatefulWidget {

  final ControladorPresentacion controladorPresentacion;

  final String uid;

  const EditPerfil({Key? key, required this.controladorPresentacion, required this.uid}) : super(key: key);

  @override
  State<EditPerfil> createState() => _EditPerfil(this.controladorPresentacion, this.uid);
}

class _EditPerfil extends State<EditPerfil> {
  //Usuari de Firebase
  int _selectedIndex = 3;

  late String _uid;

  late Future<String?> _usernameFuture;

  //Instancia de autentificacio de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late ControladorPresentacion _controladorPresentacion;

  bool privat = false;

  final TextEditingController usernameController = TextEditingController();
  List<String> selectedCategories = [];

  final List<String> _categories = [
    'festa',
    'infantil',
    'circ',
    'commemoració',
    'exposicions',
    'art',
    'carnaval',
    'concerts',
    'conferencies',
    'rutes',
    'activitats Virtuals',
    'teatre'
  ];

  late User? user;
  
  _EditPerfil(ControladorPresentacion controladorPresentacion, String uid) {
    _controladorPresentacion = controladorPresentacion;
    user = controladorPresentacion.getUser();
    _uid = uid;
    selectedCategories = controladorPresentacion.getCategsFav();
  }

  @override
  void initState() {
    super.initState();
    _usernameFuture = widget.controladorPresentacion.getUsername(_uid);
  }

  @override
  Widget build(BuildContext context) {
    print(selectedCategories.toString());
    return FutureBuilder<String?>(
      future: _usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            // Asigna un tamaño específico al contenedor
            width: 50, // Por ejemplo, puedes ajustar el ancho según tus necesidades
            height: 50, // También puedes ajustar la altura según tus necesidades
            child: CircularProgressIndicator(color: Colors.orange),
          );
        } else if (snapshot.hasError) {
          return Text("profile_error_msg".tr(context));
        } else {
          // Muestra el nombre de usuario obtenido
          final username = snapshot.data ?? '';
          return _buildUserInfo(username);
        }
      },
    );
  }

  Widget _buildUserInfo(String username) {
    usernameController.text = username;
    return Scaffold(
      //Header
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Edit',
          style: TextStyle(color: Colors.white),
        ),
      ),      
      //opcions de edicio
      body: _editProfileScreen(context)
    );
  }

  Widget _editProfileScreen(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
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
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
              onTap: () {
                editUser();
              },
              child: Text(
                'Guardar',
                textAlign: TextAlign.right, // Alineado a la derecha
                style: TextStyle(
                  color: Color.fromARGB(244, 255, 145, 0), // Color principal
                  fontWeight: FontWeight.bold, // Negrita
                  fontSize: 16, // Tamaño de fuente 16
                  decoration: TextDecoration.none, // Sin decoración
                ),
              ),
            ),
            ],
          ),

    );
  }

  Future<void> editUser() async {
    bool ok = await _controladorPresentacion.usernameUnique(usernameController.text);
    bool ok2 = await sameName();
    print("Ok" + ok.toString());
    print("Same name" + sameName().toString());
    if (ok2 || ok) {
      _controladorPresentacion.editUser(usernameController.text, selectedCategories, context);
    }
    else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Ja hi ha un usuari amb aquest username'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showMultiSelect() async {
    await showDialog(
      context: context,
      builder: (contex) {
        List<String> valoresSeleccionados = _categories.where((categoria) => selectedCategories.contains(categoria)).toList();
        return  MultiSelectDialog(
          items: _categories
                .map((categoria) => MultiSelectItem<String>(categoria.toLowerCase(), categoria.toLowerCase()))
                .toList(),
          listType: MultiSelectListType.CHIP,
          initialValue: valoresSeleccionados,
          onConfirm: (values) {
             selectedCategories = values.take(3).toList();
             valoresSeleccionados = _categories.where((categoria) => selectedCategories.contains(categoria)).toList();
          },
          selectedColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
          checkColor: Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
          unselectedColor: Colors.white,
        );
      },
    );
  }
  
  Future<bool> sameName() async {
    String? name = await _usernameFuture;
    return usernameController.text == name;
  }
}

