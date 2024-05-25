import 'package:culturapp/presentacio/screens/categorias.dart';
import 'package:culturapp/translations/AppLocalizations';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:culturapp/presentacio/controlador_presentacio.dart';

class Signup extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const Signup({Key? key, required this.controladorPresentacion}) : super(key: key);

  @override
  _SignupState createState() => _SignupState(controladorPresentacion);
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  List<String> selectedCategories = [];

  final List<String> _categories = [
    'Festa',
    'Infantil',
    'Circ',
    'Commemoració',
    'Exposicions',
    'Art',
    'Carnaval',
    'Concerts',
    'Conferencies',
    'Rutes',
    'Activitats Virtuals',
    'Teatre'
  ];
  
  late ControladorPresentacion _controladorPresentacion;
  bool _isLoading = false;

  late User? user;

  _SignupState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    user = controladorPresentacion.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _buildLoadingScreen() : _signupScreen(context),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Añade esta línea
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 250),
              ),
              const SizedBox(
                child: CircularProgressIndicator(
                    color: Color(0xFFF4692A)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 225.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png',
                      width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text('CulturApp',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signupScreen(BuildContext context) {
    return SingleChildScrollView(
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
                Text(
                  "create_account".tr(context),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "add_info".tr(context),
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
                    hintText: "username".tr(context),
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromARGB(244, 255, 145, 0).withOpacity(0.1),
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
                          return const Color.fromARGB(244, 255, 145, 0).withOpacity(0.1);
                        },
                      ),
                      shadowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Colors.transparent;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 15)),
                      alignment: Alignment.centerLeft
                    ),
                    onPressed: _showMultiSelect,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[800],),
                    label: Text("favourite_categories".tr(context), style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              child: ElevatedButton(
                onPressed: () async {
                  if (await _validateInputs()) {
                    await createUser();
                    _controladorPresentacion.mostrarMapa(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(244, 255, 145, 0),
                ),
                child: Text(
                  "create_account".tr(context),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _validateInputs() async {
    if (usernameController.text.isEmpty) {
      _showErrorMessage('Por favor, ingrese un nombre de usuario');
      return false;
    }
    if (selectedCategories.length < 3) {
      _showErrorMessage('Por favor, selecciona al menos 3 categorías');
      return false;
    }
    if (!await _controladorPresentacion.usernameUnique(usernameController.text)) {
       _showErrorMessage('Ya existe un usuario con este nombre de usuario');
       return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

Future<void> createUser() async {
  setState(() {
    _isLoading = true;
  });

  try {
    
      await _controladorPresentacion.createUser(usernameController.text, selectedCategories, context);
      await _controladorPresentacion.initialice2();
      await _controladorPresentacion.initialice();
      setState(() {
        _isLoading = false;
      });
  } catch (error) {
    setState(() {
      _isLoading = false;
    });
    _showErrorMessage('Error al crear el usuario: $error');
  }
}

 void _showMultiSelect() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Categorias(selected: selectedCategories),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCategories = result;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
