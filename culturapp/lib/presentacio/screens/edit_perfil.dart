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

  final String username;

  const EditPerfil({Key? key, required this.controladorPresentacion, required this.username}) : super(key: key);

  @override
  State<EditPerfil> createState() => _EditPerfil(this.controladorPresentacion, this.username);
}

class _EditPerfil extends State<EditPerfil> {
  //Usuari de Firebase
  int _selectedIndex = 3;

  late String _username;
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
  
  _EditPerfil(ControladorPresentacion controladorPresentacion, String username) {
    _controladorPresentacion = controladorPresentacion;
    _username = controladorPresentacion.getUsername();
    selectedCategories = controladorPresentacion.getCategsFav();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedCategories.toString());
    return Builder(
  builder: (context) {
    // Aquí puedes acceder a los datos que necesitas para construir tu widget.
    // Como Builder no maneja Futures, necesitarás obtener los datos de otra manera.
    // Por ejemplo, podrías obtener los datos en un método initState y almacenarlos en una variable de estado.
    final username = this._username ?? ''; // Reemplaza esto con tu lógica para obtener el nombre de usuario

    if (username.isEmpty) {
      return Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        child: CircularProgressIndicator(color: const Color(0xFFF4692A)),
      );
    } else {
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
        backgroundColor: const Color(0xFFF4692A),
        title: Text(
          'edit'.tr(context),
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
                      label: Text("favourite_categories".tr(context), style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
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
          title: Text("select".tr(context)),
          confirmText: Text("ok".tr(context)),
          cancelText: Text("cancel".tr(context)),
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
    String? name = await _username;
    return usernameController.text == name;
  }
}

