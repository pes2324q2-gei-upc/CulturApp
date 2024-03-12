import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:hive/hive.dart";
import "package:sign_in_button/sign_in_button.dart";
import 'package:culturapp/presentacio/routes/routes.dart';
import 'package:culturapp/presentacio/screens/logout.dart';
import 'package:culturapp/presentacio/screens/signup.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

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
      _checkLoggedInUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginLayout(),
    );
  }

  Widget _loginLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Benvingut a CulturApp",
        ),
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

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(_user!.photoURL!)))
        ),
        Text(_user!.email!),
        Text(_user!.displayName ?? ""),
        MaterialButton(
          color: Colors.red,
          child: const Text("Sign out"),
          onPressed: _auth.signOut,)
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists = await accountExists(userCredential.user);
      if (!userExists) {
        createUser(_user);
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Signup(_user))
      );
      }
      else {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Logout(_user))
      );
      }
    }
    catch (error) {
      print(error);
    }
  }
  
  Future<bool> accountExists(User? user) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection("users").doc(_user!.uid).get();
    return userSnapshot.exists;
  }
  
  void createUser(User? user) {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    usersCollection.doc(_user?.uid).set({
      'email': _user?.email,
      'name': _user?.displayName,
    });
  }

  void _checkLoggedInUser() async {
    User? currentUser = _auth.currentUser; // Obtener el usuario actualmente autenticado
    
    if (currentUser != null) {
      setState(() {
        _user = currentUser; // Establece el usuario en el estado
      });
      
      // Navegar a la página de Logout
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Logout(_user))
      );
    }
  }
}

