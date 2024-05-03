import 'package:culturapp/translations/AppLocalizations';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;


class ListaMisActividades extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final User? user;
  
  ListaMisActividades({
    Key? key,
    required this.controladorPresentacion, required this.user,
  }) : super(key: key);

  @override
  State<ListaMisActividades> createState() => _ListaMisActividadesState(
        controladorPresentacion, user);
}

class _ListaMisActividadesState extends State<ListaMisActividades> {
  late List<Actividad> activitats = [];
  late List<Actividad> display_list = [];
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String squery;
  late String? _selectedCategory;
  late String selectedData;
  late User? usuario; //SOBRA DEBIDO LÓGICA GET ACTIVITATS USER
  int _selectedIndex = 1;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  calendar.CalendarApi? _calendarApi;

  static const List<String> llistaCategories = <String>[
    '-totes-',
    'concerts',
    'infantil',
    'teatre',
    'festes',
    'circ',
    'cicles',
    'nadal',
    'fires-i-mercats',
    'rutes-i-visites',
    'cursos',
    'dansa',
    'festivals-i-mostres',
    'activitats-virtuals',
    'exposicions'
  ];

  _ListaMisActividadesState(ControladorPresentacion controladorPresentacion, User? user) {
    _controladorPresentacion = controladorPresentacion;
    squery = '';
    _selectedCategory = '-totes-';
    selectedData = '';
  }

  @override
  void initState() {
    super.initState();
    fetchActivities().then((value) {
      setState(() {
        activitats = value;
        display_list = activitats;
      });
    }).catchError((error) {
      print("Error fetching activities: $error");
    });
  }


 Future<void> agregarEventoGoogleCalendar(String nameAct, String date) async {
    final FirebaseAuth authFirebase = FirebaseAuth.instance;
    final User? user = authFirebase.currentUser;
    final idTokenResult = await user!.getIdTokenResult();
    final idToken = idTokenResult.token;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/calendar',
      ],
    );
    GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleAuth;
    if (googleUser == null) {
      try {
        googleUser = await googleSignIn.signIn();  
      } catch (e) {
        print('Error al iniciar sesión: $e');
        return; 
      }
      if (googleUser != null) {
        googleAuth = (await googleUser.authentication)!;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else {
        return; 
      }
    } else {
      googleAuth = await googleUser.authentication;
    }

    if (googleAuth.accessToken != null) {
      final authClient = auth.authenticatedClient(
        http.Client(),
        auth.AccessCredentials(
          auth.AccessToken(
            'Bearer',
            googleAuth.accessToken!,
            DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
          idToken,
          [calendar.CalendarApi.calendarScope],
        ),
      );
        
      final calendarApi = calendar.CalendarApi(authClient);

      DateFormat formatter = DateFormat("yyyy-MM-dd");
      DateTime data = formatter.parse(date);

      int year = data.year;
      int month = data.month;
      int day = data.day;

      var event = calendar.Event()
        ..summary = nameAct
        ..start = (calendar.EventDateTime()..date = DateTime(year, month, day))
        ..end = (calendar.EventDateTime()..date = DateTime(year, month, day));

      var request = calendarApi.events.insert(event, 'primary');
      var addedEvent = await request;

      print('Evento añadido: ${addedEvent.id}');
    } else {
      print('No se pudo obtener el token de acceso');
    }
  }

  Future<List<Actividad>> fetchActivities() async {
    var actividadesaux = <Actividad>[];
    actividadesaux = await _controladorPresentacion.getUserActivities();
    return actividadesaux;
  }

  String getCategoria(Actividad actividad) {
    try {
      return actividad.categoria.toString();
    } catch (error) {
      return "default";
    }
  }

  void changeSquery(String text) {
    squery = text;
  }

  void clearSearchBar() {
    _searchController.clear();
  }

  void searchMyActivities(String squery) async {
    try {
      display_list = await _controladorPresentacion.searchMyActivitats(squery);
    } on Exception catch (_, ex) {
      print(ex);
    }
    setState(() {});
  }

  void canviFiltreData(String date) {
    DateTime selectedDate = DateTime.parse(date);
    selectedData = date;
    clearSearchBar();
    setState(() {
      display_list = activitats.where((activity) {
        if (activity.dataInici != 'No disponible') {
          DateTime activityDate = DateTime.parse(activity.dataInici);
          if (_selectedCategory != '-totes-') {
            return (activityDate.isAfter(selectedDate) ||
                    activityDate.isAtSameMomentAs(selectedDate)) &&
                activity.categoria.contains(_selectedCategory);
          } else {
            return activityDate.isAfter(selectedDate) ||
                activityDate.isAtSameMomentAs(selectedDate);
          }
        } else {
          return false;
        }
      }).toList();
    });
  }

  void filterActivitiesByCategory(String category) async {
    clearSearchBar();

    setState(() {
      if (category == '-totes-') {
        if (selectedData != '') {
          display_list = activitats.where((activity) {
            DateTime activityDate = DateTime.parse(activity.dataInici);
            DateTime selectedDate = DateTime.parse(selectedData);

            return (activityDate.isAfter(selectedDate) ||
                activityDate.isAtSameMomentAs(selectedDate));
          }).toList();
        }
      } else {
        if (selectedData != '') {
          display_list = activitats.where((activity) {
            DateTime activityDate = DateTime.parse(activity.dataInici);
            DateTime selectedDate = DateTime.parse(selectedData);

            return (activity.categoria.contains(category)) &&
                (activityDate.isAfter(selectedDate) ||
                    activityDate.isAtSameMomentAs(selectedDate));
          }).toList();
        } else {
          display_list = activitats
              .where((activity) => activity.categoria.contains(category))
              .toList();
        }
      }
    });
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _controladorPresentacion.mostrarMapa(context);
        break;
      case 1:
        _controladorPresentacion.mostrarActividadesUser(context);
        break;
      case 2:
        _controladorPresentacion.mostrarXats(context);
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  void addActivityToCalendar(Actividad act){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("my_activities".tr(context)),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildCercador(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    _buildFiltreCategoria(),
                    const SizedBox(
                      width: 10.0,
                    ),
                    _buildFiltreData(),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: display_list.length,
              itemBuilder: (context, index) {
                final Actividad activitat;
                if (index < display_list.length) {
                  activitat = display_list[index];
                  return GestureDetector(
                    onTap: () async {
                      List<String> act = [
                        activitat.name,
                        activitat.code,
                        activitat.categoria[0],
                        activitat.imageUrl,
                        activitat.descripcio,
                        activitat.dataInici,
                        activitat.dataFi,
                        activitat.ubicacio
                      ];
                      _controladorPresentacion.mostrarVerActividad(
                          context, act, activitat.urlEntrades);
                      DocumentReference docRef = _firestore
                          .collection('actividades')
                          .doc(activitat.code);
                      await _firestore.runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(docRef);
                        int currentValue = 0;
                        if (snapshot.data() is Map<String, dynamic>) {
                          currentValue = (snapshot.data()
                                  as Map<String, dynamic>)['visualitzacions'] ??
                              5;
                        }
                        int newValue = currentValue + 1;
                        transaction
                            .update(docRef, {'visualitzacions': newValue});
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 24.0,
                            right: 16.0,
                            left: 16.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        activitat.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF4692A),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          child: Image.network(
                                            activitat.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.location_on),
                                              Expanded(
                                                child: Text(
                                                  "  ${activitat.ubicacio}",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_month),
                                              Text(
                                                "  Inicio: ${() {
                                                  try {
                                                    return DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.parse(
                                                            activitat
                                                                .dataInici));
                                                  } catch (e) {
                                                    return 'Unknown';
                                                  }
                                                }()}",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_month),
                                              Text(
                                                "  Fin: ${() {
                                                  try {
                                                    return DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(DateTime.parse(
                                                            activitat.dataFi));
                                                  } catch (e) {
                                                    return 'Unknown';
                                                  }
                                                }()}",
                                              ),
                                            ],
                                          ),
                                      Row(
                                        children: [
                                          const Icon(Icons.local_atm),
                                          const Padding(
                                              padding: EdgeInsets.only(right: 7.5)),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                launchUrl(activitat
                                                    .urlEntrades); // abrir la url de la actividad para ir a su pagina
                                              },
                                              child: Text(
                                                'buy_here'.tr(context),
                                                style: TextStyle(
                                                  decoration: TextDecoration
                                                      .none,
                                                      color: Colors.blueAccent // Subrayar para que se entienda que es un enlace
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 8)),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 180,
                                            child: TextButton(
                                              onPressed: () {
                                               agregarEventoGoogleCalendar(activitat.name, activitat.dataInici);
                                              },
                                              child: Row(
                                                children: [
                                                  Text('add_calendar'.tr(context), style: TextStyle(color: Color.fromARGB(255, 255, 196, 0)),),
                                                  const Padding(padding: EdgeInsets.only(right: 5)),
                                                  Image.asset('assets/calendar.png', height: 30,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCercador() {
    return SizedBox(
      height: 40.0,
      child: TextField(
        controller: _searchController,
        onChanged: (text) => changeSquery(text),
        cursorColor: const Color(0xFFF4692A),
        style: const TextStyle(
          color: Color(0xFFF4692A),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(255, 229, 204, 0.815),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xFFF4692A),
            ),
          ),
          hintText: "search".tr(context),
          hintStyle: const TextStyle(
            color: Color(0xFFF4692A),
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              searchMyActivities(squery);
            },
            icon: const Icon(Icons.search),
          ),
          suffixIconColor: const Color(0xFFF4692A),
        ),
      ),
    );
  }

  Widget _buildFiltreCategoria() {
    return SizedBox(
      height: 30.0,
      width: 200.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 200,
          height: 30,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 229, 204, 0.815),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: llistaCategories.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                setState(() {
                  _selectedCategory = newValue;
                  filterActivitiesByCategory(newValue!);
                });
              },
              borderRadius: BorderRadius.circular(10),
              dropdownColor:const Color.fromRGBO(255, 229, 204, 0.815),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFF4692A),
              ),
              iconSize: 20,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF4692A),
              ),
              underline: Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltreData() {
    return SizedBox(
      height: 30.0,
      width: 150.0,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 500.0,
          child: TextField(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFF4692A),
              fontWeight: FontWeight.bold,
            ),
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'date'.tr(context),
              labelStyle: TextStyle(
                color: Color(0xFFF4692A),
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: Color.fromRGBO(255, 229, 204, 0.815),
              prefixIcon: Icon(
                Icons.calendar_today,
                size: 18,
                color: Color(0xFFF4692A),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF4692A),
                ),
              ),
            ),
            readOnly: true,
            onTap: () {
              _selectDate();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _dateController.text = formattedDate;
        canviFiltreData(formattedDate);
      });
    }
  }
}
