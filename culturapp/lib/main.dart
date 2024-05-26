// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/data/firebase_options.dart';
import 'package:culturapp/domain/converters/notificacions.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  notificacioSimple(message.notification?.title ?? "Title",
      message.notification?.body ?? "Body");
}

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

  //inicilitzar notificacions i demanar permisos
  initializeAwesomeNotifications();
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(
      controladorPresentacion: controladorPresentacion,
      currentUser: currentUser));
}

class MyApp extends StatelessWidget {
  final ControladorPresentacion controladorPresentacion;
  final User? currentUser;

  const MyApp(
      {Key? key, required this.controladorPresentacion, this.currentUser})
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
  User? currentUser;
  late Usuari currentUsuari;
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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
    _initializeFCM();
  }

  void _initializeFCM() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String name = _controladorPresentacion.getUsername();
      currentUsuari = await _controladorPresentacion.getUserByName(name);
      _firebaseMessaging.getToken().then((token) async {
        print("FCM Token: $token");

        if (token != null) {
          bool alreadyAgregat = await userTeElDevice(token, currentUsuari);
          if (!alreadyAgregat) {
            currentUsuari.devices.add(token);
            _controladorPresentacion.addDevice(
                currentUser?.uid, currentUsuari.devices);
          }
        }
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          notificacioSimple(notification.title!, notification.body!);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        // Navigate to a specific screen
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<bool> userTeElDevice(String? device, Usuari usuari) async {
    if (usuari.devices.isEmpty) return false;
    if (currentUser != null && device != null) {
      List<String> devices = usuari.devices;
      for (String device in devices) {
        if (devices.contains(device)) {
          return true;
        }
      }
      return false;
    } else {
      return true;
    }
  }

  void userLogged() async {
    currentUser = _auth.currentUser;
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
      home: Scaffold(
        body: _isLoggedIn
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
