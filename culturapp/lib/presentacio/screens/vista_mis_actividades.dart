import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaMisActividades extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  ListaMisActividades({
    Key? key,
    required this.controladorPresentacion,
  }) : super(key: key);

  @override
  State<ListaMisActividades> createState() => _ListaMisActividadesState(
        controladorPresentacion,
      );
}

class _ListaMisActividadesState extends State<ListaMisActividades> {
  late List<Actividad> activitats = [];
  late List<Actividad> display_list = [];
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String squery;
  late String? _selectedCategory;
  late String selectedData;
  int _selectedIndex = 1;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  static const List<String> llistaCategories = <String>[
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

  _ListaMisActividadesState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    squery = '';
    _selectedCategory = 'activitats-virtuals';
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

  Future<List<Actividad>> fetchActivities() async {
    var actividadesaux = <Actividad>[];
    actividadesaux = await _controladorPresentacion.getMisActivitats();
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
          if (_selectedCategory != '') {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Mis actividades"),
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
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (text) => changeSquery(text),
                    cursorColor: Colors.orange,
                    style: const TextStyle(
                      color: Colors.orange,
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
                          color: Colors.orange,
                        ),
                      ),
                      hintText: "Search...",
                      hintStyle: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchMyActivities(squery);
                        },
                        icon: Icon(Icons.search),
                      ),
                      suffixIconColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 30.0,
                      width: 200.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 229, 204, 0.815),
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
                              dropdownColor:
                                  Color.fromRGBO(255, 229, 204, 0.815),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.orange,
                              ),
                              iconSize: 20,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              underline: Container(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      height: 30.0,
                      width: 150.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 500.0,
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: _dateController,
                            decoration: const InputDecoration(
                              labelText: 'Data',
                              labelStyle: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 229, 204, 0.815),
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.orange,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange,
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
                    ),
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
                      DocumentReference docRef =
                          _firestore.collection('actividades').doc(activitat.code);
                      await _firestore.runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(docRef);
                        int currentValue = 0;
                        if (snapshot.data() is Map<String, dynamic>) {
                          currentValue = (snapshot.data() as Map<String, dynamic>)['visualitzacions'] ?? 5;
                        }
                        int newValue = currentValue + 1;
                        transaction.update(docRef, {'visualitzacions': newValue});
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 32.0,
                            right: 16.0,
                            left: 16.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        activitat.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
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
                                                  overflow: TextOverflow.ellipsis,
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
                                                    return DateFormat('yyyy-MM-dd').format(DateTime.parse(activitat.dataInici));
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
                                                    return DateFormat('yyyy-MM-dd').format(DateTime.parse(activitat.dataFi));
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
                                              TextWithLink(
                                                text: "  Compra aqui",
                                                url: activitat.urlEntrades
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 5),
                                          width: 50,
                                          child: ImageCategory(
                                            categoria: getCategoria(activitat),
                                          ),
                                        ),
                                      ],
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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_picked);
      setState(() {
        _dateController.text = formattedDate;
        canviFiltreData(formattedDate);
      });
    }
  }
}
