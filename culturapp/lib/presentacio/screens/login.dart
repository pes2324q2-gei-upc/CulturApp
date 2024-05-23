import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const Login({Key? key, required this.controladorPresentacion});

  @override
  State<Login> createState() => _Login(controladorPresentacion);
}

class _Login extends State<Login> {
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool userExists = false;

  _Login(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _buildLoadingScreen() : _loginLayout(),
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

  Widget _loginLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "welcome_txt".tr(context),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 70),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginpicture.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 70),
        _googleSignInButton(),
      ],
    );
  }

  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), // Color de la sombra
                spreadRadius: 2, // Extensión de la sombra
                blurRadius: 5, // Desenfoque de la sombra
                offset: Offset(0, 3), // Posición de la sombra
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0), // Bordes redondeados del contenido recortado
            child: SignInButton(
              Buttons.google,
              onPressed: () async {
                try {
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  if (googleUser != null) {
                    setState(() {
                      _isLoading = true; 
                    });

                    await _handleGoogleSignIn(googleUser);

                    if (userExists) {
                      _controladorPresentacion.mostrarMapa(context);
                    } else {
                      _controladorPresentacion.mostrarSignup(context);
                    }
                  }
                } catch (error) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              text: "google_access".tr(context),
              padding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
      ),
    );
  }



  Future<void> iniciaApp() async {
    await _controladorPresentacion.initialice2();
    await _controladorPresentacion.initialice();
  }

  Future<void> _handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    userExists =
        await _controladorPresentacion.checkUserExists(userCredential);

    if (userExists) {
      await iniciaApp();
    }

    setState(() {
      _isLoading = false;
    });
  }
}
