import 'dart:io';
import 'dart:typed_data';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/categorias.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class EditPerfil extends StatefulWidget {

  final ControladorPresentacion controladorPresentacion;

  final String username;

  const EditPerfil({Key? key, required this.controladorPresentacion, required this.username}) : super(key: key);

  @override
  State<EditPerfil> createState() => _EditPerfil(this.controladorPresentacion, this.username);
}

class _EditPerfil extends State<EditPerfil> {

  late String _username;

  late ControladorPresentacion _controladorPresentacion;

  bool privat = false;

  final TextEditingController usernameController = TextEditingController();
  List<String> selectedCategories = [];

  Uint8List? _image;

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

  Future<void> _requestGalleryPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      assignarImatge();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gallery permission is required to select an image.'),
        ),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    print(selectedCategories.toString());
    return Builder(
      builder: (context) {
        // Aquí puedes acceder a los datos que necesitas para construir tu widget.
        // Como Builder no maneja Futures, necesitarás obtener los datos de otra manera.
        // Por ejemplo, podrías obtener los datos en un método initState y almacenarlos en una variable de estado.
        final username = _username; 

        if (username.isEmpty) {
          return Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            child: const CircularProgressIndicator(color:Color(0xFFF4692A)),
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
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso
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
              _buildEscollirImatge(),
              Column(
                children: <Widget>[
                  TextField(
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Nom d'usuari",
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
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  editUser();
                },
                child: const Text(
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
    Usuari usr = await _controladorPresentacion.getUserByName(_username);
    String img = usr.image;
    bool ok = await _controladorPresentacion.usernameUnique(usernameController.text);
    bool ok2 = await sameName();
    if (ok2 || ok) {
      _controladorPresentacion.editUser(usernameController.text, selectedCategories, context, img, _image);
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
  }

  void assignarImatge() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if(_file != null) {
      return await _file.readAsBytes();
    }
  }

  Future<String> getImg() async {
    Usuari usr =  await _controladorPresentacion.getUserByName(_username);
    return usr.image;
  }

  Widget _buildEscollirImatge() { 
    return Column(
      children: [
        const Text(
          'Imatge:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Stack (
            children: [
              _image != null ? 
                CircleAvatar(
                  backgroundImage: MemoryImage(_image!),
                  radius: 65,
                )
              : FutureBuilder<String>(
                  future: getImg(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        radius: 65,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const CircleAvatar(
                        backgroundImage: AssetImage('assets/userImage.png'),
                        radius: 65,
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!),
                        radius: 65,
                      );
                    } else {
                      return const CircleAvatar(
                        backgroundImage: AssetImage('assets/userImage.png'),
                        radius: 65,
                      );
                    }
                  },
                ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: _requestGalleryPermission,
                  icon: const Icon(Icons.add_a_photo),
                )
              )
            ],
          )
        ),
      ],
    );
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
  
  Future<bool> sameName() async {
    String? name = _username;
    return usernameController.text == name;
  }
}

