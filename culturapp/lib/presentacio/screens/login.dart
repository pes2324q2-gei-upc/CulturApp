import "package:cloud_firestore/cloud_firestore.dart";
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:hive/hive.dart";
import "package:sign_in_button/sign_in_button.dart";
//import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
//import 'package:culturapp/presentacio/routes/routes.dart';


class Login extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const Login({Key? key, required this.controladorPresentacion});

  @override
  State<Login> createState() => _Login(controladorPresentacion);
}

class _Login extends State<Login> {
  
  late ControladorPresentacion _controladorPresentacion;

  late FirebaseAuth _auth = FirebaseAuth.instance;

  _Login(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
    /*
    _auth.authStateChanges().listen((event) {
      setState(() {
        _controladorPresentacion.setUser(event);
      });
      _controladorPresentacion.checkLoggetInUser(context);
    });*/
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //Comprovar si ja hi ha una sessio iniciada
      _controladorPresentacion.checkLoggedInUser(context);
    });
  }

  //Construccio de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginLayout(),
    );
  }

  //Layout de login
  Widget _loginLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Benvingut a CulturApp",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        const SizedBox(height: 70),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginpicture.png'),
              fit: BoxFit.cover,
            )
          ),
        ),
        const SizedBox(height: 70),
        _googleSignInButton(),
      ],
    );
  }

  //Botó de login
  Widget _googleSignInButton() {
    return Center(child: SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.google,
        onPressed: () {
          _handleGoogleSignIn();
        },
        text: "Accedeix amb Google",
        padding: const EdgeInsets.all(10.0),
      )
    ));
  }
 
  //Inici de sessio
  Future<void> _handleGoogleSignIn() async {
    await _controladorPresentacion.handleGoogleSignIn(context);
  }
}

