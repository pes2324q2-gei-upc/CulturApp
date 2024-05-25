// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final controladorPresentacion = ControladorPresentacion();

  User? currentUser = FirebaseAuth.instance.currentUser;
  await controladorPresentacion.initialice2();
  if (currentUser != null) {
    await controladorPresentacion.initialice();
  }

  AwesomeNotifications().initialize(
    null, //'assets/logoCulturApp.png',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for everything',
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(FadeTransition(
    opacity: AlwaysStoppedAnimation(1), // Configura la opacidad a 1 para evitar un efecto de desvanecimiento inicial
    child: MyApp(
      controladorPresentacion: controladorPresentacion,
      currentUser: currentUser,
    ),
  ));

}

class MyApp extends StatelessWidget {
  final ControladorPresentacion controladorPresentacion;
  final User? currentUser;

  const MyApp(
      {Key? key,
      required this.controladorPresentacion,
      this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentUser != null
          ? Future.wait([
              controladorPresentacion.initialice(),
              controladorPresentacion.initialice2(),
            ])
          : controladorPresentacion.initialice2(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
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
              ),
            ),
          
          );
        } else {
          return _MyAppState(controladorPresentacion: controladorPresentacion);
        }
      },
    );
  }
}

class _MyAppState extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const _MyAppState({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  __MyAppStateState createState() => __MyAppStateState(controladorPresentacion);
}

class __MyAppStateState extends State<_MyAppState> {
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  MaterialColor mainColor = const MaterialColor(0xFFF4692A, <int, Color>{
    50: Color(0xFFF4692A),
    100: Color(0xFFF4692A),
    200: Color(0xFFF4692A),
    300: Color(0xFFF4692A),
    400: Color(0xFFF4692A),
    500: Color(0xFFF4692A),
    600: Color(0xFFF4692A),
    700: Color(0xFFF4692A),
    800: Color(0xFFF4692A),
    900: Color(0xFFF4692A),
  });

  bool _isLoading = true;

  __MyAppStateState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
    userLogged();
  }

  void userLogged() async {
    User? currentUser = _auth.currentUser;
    setState(() {
      _isLoggedIn = currentUser != null;
      _selectedIndex = _isLoggedIn ? _selectedIndex : 4;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: [
                    const SizedBox(
                      child:
                          CircularProgressIndicator(color: Color(0xFFF4692A)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png', width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text('CulturApp', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: mainColor,
      ),
      supportedLocales: const [
        Locale('en'),
        Locale('ca'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (_controladorPresentacion.language != null) {
          return _controladorPresentacion.language;
        }
        for (var locale in supportedLocales) {
          if (deviceLocale != null &&
              deviceLocale.languageCode == locale.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      home: FadeTransition(
        opacity: AlwaysStoppedAnimation(1),
        child: _isLoggedIn
          ? MapPage(
              controladorPresentacion: _controladorPresentacion,
              vencidas: _controladorPresentacion.getActividadesVencidas(),
            )
          : Login(
              controladorPresentacion: _controladorPresentacion,
            ),
      ),
    );
  }
}
