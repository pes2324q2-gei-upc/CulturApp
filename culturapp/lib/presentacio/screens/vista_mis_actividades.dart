// ignore_for_file: prefer_const_constructors

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

    final List<String> catsAMB = [
    "Residus",
    "territori.espai_public_platges",
    "Sostenibilitat",
    "Aigua",
    "territori.espai_public_parcs",
    "Espai públic - Rius",
    "Espai públic - Parcs",
    "Portal de transparència",
    "Mobilitat sostenible",
    "Internacional",
    "Activitat econòmica",
    "Polítiques socials",
    "territori.espai_public_rius",
    "Espai públic - Platges"
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Actividad añadida a Google Calendar'),
          duration: Duration(seconds: 3),
        ),
      );

    } else {
      print('No se pudo obtener el token de acceso');
    }
  }

  Future<List<Actividad>> fetchActivities() async {
    var actividadesaux = <Actividad>[];
    actividadesaux = await _controladorPresentacion.getUserActivs();
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
        _controladorPresentacion.mostrarXats(context, 'Amics');
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  Image _retornaIcon(String categoria) {
    if (catsAMB.contains(categoria)) {
      return Image.asset(
        'assets/categoriareciclar.png',
        width: 45.0,
      );
    } else {
      switch (categoria) {
        case 'carnavals':
          return Image.asset(
            'assets/categoriacarnaval.png',
            width: 45.0,
          );
        case 'teatre':
          return Image.asset(
            'assets/categoriateatre.png',
            width: 45.0,
          );
        case 'concerts':
          return Image.asset(
            'assets/categoriaconcert.png',
            width: 45.0,
          );
        case 'circ':
          return Image.asset(
            'assets/categoriacirc.png',
            width: 45.0,
          );
        case 'exposicions':
          return Image.asset(
            'assets/categoriaarte.png',
            width: 45.0,
          );
        case 'conferencies':
          return Image.asset(
            'assets/categoriaconfe.png',
            width: 45.0,
          );
        case 'commemoracions':
          return Image.asset(
            'assets/categoriacommemoracio.png',
            width: 45.0,
          );
        case 'rutes-i-visites':
          return Image.asset(
            'assets/categoriaruta.png',
            width: 45.0,
          );
        case 'cursos':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'activitats-virtuals':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'infantil':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'festes':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'festivals-i-mostres':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'dansa':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'cicles':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'cultura-digital':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'fires-i-mercats':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'gegants':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        default:
          return Image.asset(
            'assets/categoriarecom.png',
            width: 45.0,
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("my_activities".tr(context), style: TextStyle(color: Colors.white,)),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Column(
        children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  _buildCercador(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFiltreCategoria(),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: _buildFiltreData(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
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
                        activitat.categoria.join(', '),
                        activitat.imageUrl,
                        activitat.descripcio,
                        activitat.dataInici,
                        activitat.dataFi,
                        activitat.ubicacio,
                        activitat.latitud.toString(),
                        activitat.longitud.toString(),
    
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
                          child: Column(children: [
                          Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: activitat.dataInici != activitat.dataFi ? 150.0 : 120.0,
                                  width: activitat.dataInici != activitat.dataFi ? 150.0 : 120.0, 
                                  child: Image.network(
                                    activitat.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Flexible(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            activitat.name,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFF4692A),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 5.0)),
                                        _retornaIcon(activitat.categoria[
                                            0]),
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 7.5)),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 7.5)),
                                        Expanded(
                                          child: Text(
                                            activitat.ubicacio,
                                            overflow: TextOverflow
                                                .ellipsis, 
                                          ),
                                        ),
                                      ],
                                    ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month),
                                  const Padding(padding: EdgeInsets.only(right: 7.5)),
                                  Text(activitat.dataInici),
                                ],
                              ),
                              activitat.dataInici != activitat.dataFi
                                  ? Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const Padding(padding: EdgeInsets.only(right: 7.5)),
                                        Text(activitat.dataFi),
                                      ],
                                    )
                                  : Container(),
                                    Row(
                                      children: [
                                        const Icon(Icons.local_atm),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 7.5)),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              launchUrl(activitat
                                                  .urlEntrades);
                                            },
                                            child: Text(
                                              'tickets_info'.tr(context),
                                              style: const TextStyle(
                                                decoration: TextDecoration
                                                    .underline, color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                          Row(
                          children: [
                          SizedBox(
                            height: 32.5,// Reducir el ancho para hacer el botón más pequeño
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: BorderSide(color: Colors.black,),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                agregarEventoGoogleCalendar(activitat.name, activitat.dataInici);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  Text(
                                    'add_calendar'.tr(context), style: TextStyle(fontSize: 12),
                                  ),
                                  const Padding(padding: EdgeInsets.only(right: 5)),
                                  const Icon(Icons.calendar_month),
                                ],
                              ),
                            ),
                          ),
                           const Padding(padding: EdgeInsets.only(right: 10)),
                            Align( 
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                height: 32.5,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, 
                                    backgroundColor: Colors.black,
                                  ),
                                  icon: const Icon(Icons.location_on),
                                  label: Text( 
                                    'Como llegar',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () async {
                                    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${activitat.latitud},${activitat.longitud}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      throw 'No se pudo abrir $url';
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                          ],),
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
      height: 50.0,
      child: TextField(
        controller: _searchController,
        onChanged: (text) => changeSquery(text),
        cursorColor: Color(0xFF333333),
        style: const TextStyle(
          color: Color(0xFF333333),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: "search".tr(context),
          hintStyle: const TextStyle(
            color: Color(0xFF333333),
            
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0), // Ajusta el padding a la derecha según sea necesario
            child: IconButton(
              onPressed: () {
                searchMyActivities(squery);
              },
              icon: const Icon(Icons.search),
            ),
          ),
          suffixIconColor: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildFiltreCategoria() {
    return Container(
      height: 35.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 200,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1.5),
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
                color: Color(0xFF333333),
              ),
              iconSize: 20,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              underline: Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltreData() {
  return Container(
    height: 35.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey, width: 1.5),
    ),
    child: Align(
      alignment: Alignment.center,
      child: Container(
        width: 500.0,
        child: TextField(
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
          controller: _dateController,
          decoration: InputDecoration(
            labelText: _dateController.text.isNotEmpty ? '' : 'date'.tr(context),
            border: InputBorder.none,
            fillColor: Colors.white,
            prefixIcon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF333333),
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