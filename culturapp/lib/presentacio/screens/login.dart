import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:hive/hive.dart";
import "package:sign_in_button/sign_in_button.dart";
import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/routes/routes.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  //Instancia d'autentificacio de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Usuari de Firebase
  User? _user;

  //Instancia de base de dades de Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //Comprovar si ja hi ha una sessio iniciada
      _checkLoggedInUser();
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
        Text("Benvingut a CulturApp",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        SizedBox(height: 70),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginpicture.png'),
              fit: BoxFit.cover,
            )
          ),
        ),
        SizedBox(height: 70),
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
        padding: EdgeInsets.all(10.0),
      )
    ));
  }
 
  //Inici de sessio
  Future<void> _handleGoogleSignIn() async {
    try {
      //Iniciar la sessio amb el compte especificat per l'usuari
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists = await accountExists(userCredential.user);

      //Si no hi ha un usuari associat al compte de google, redirigir a la pantalla de registre
      if (!userExists) {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Signup(_user))
        );
      }
      //Altrament redirigir a la pantalla principal de l'app
      else {
        Navigator.pushNamed(context, Routes.perfil);
      }
    }
    catch (error) {
      print(error);
    }
  }
  
  //Comprovar si existeix un usuari per a cert compte de google
  Future<bool> accountExists(User? user) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("users").doc(_user!.uid).get();
    return userSnapshot.exists;
  }

  //Comprovar si hi ha una sessio iniciada
  void _checkLoggedInUser() async {
    //Obte l'usuari autentificat en el moment si existeix
    User? currentUser = _auth.currentUser;
    
    //Si existeix l'usuari, estableix l'usuari de l'estat i redirigeix a la pantalla principal
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
     Navigator.pushNamed(context, Routes.perfil);
    }
  }
}

