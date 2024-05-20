import 'package:culturapp/presentacio/screens/categorias.dart';
import 'package:culturapp/translations/AppLocalizations';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
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
                            borderRadius: BorderRadius.circular(18.0), // Ajusta el radio de los bordes aquí
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 15)),
                        alignment: Alignment.centerLeft
                      ),
                      onPressed: _showMultiSelect,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey[800],),
                      label: Text("favourite_categories".tr(context), style: TextStyle(fontSize: 16, color: Colors.grey[700]),),
                    ),
                  )

                  ,
                  
                  const SizedBox(height: 20),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                  onPressed: () {
                    createUser().then((_) {
                      _controladorPresentacion.mostrarMapa(context);
                    });
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
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    setState(() {
      _isLoading = true;
    });
    if (selectedCategories.length < 3) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos 3 categorías'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (await _controladorPresentacion.usernameUnique(usernameController.text)) {
      setState(() {
        _isLoading = false;
      });
      await _controladorPresentacion.createUser(usernameController.text, selectedCategories, context);
      await _controladorPresentacion.initialice2();
      await _controladorPresentacion.initialice();
    }
    else {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Ja hi ha un usuari amb aquest username'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
      print(selectedCategories);
    });
  }
}


  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
