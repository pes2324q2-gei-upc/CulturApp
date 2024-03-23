import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/filtre_categoria.dart';
import 'package:culturapp/domain/models/filtre_data.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaMisActividades extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  ListaMisActividades({
    super.key,
    required this.controladorPresentacion,
  });

  @override
  State<ListaMisActividades> createState() => _ListaMisActividadesState(
        controladorPresentacion,
      );
}

class _ListaMisActividadesState extends State<ListaMisActividades> {
  late List<Actividad> activitats;
  late List<Actividad> display_list;
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String squery;
  late String? _selectedCategory;
  late String selectedData;
  TextEditingController _dateController = TextEditingController();

  static const List<String> llistaCategories = <String>[
    'concert',
    'infantil',
    'teatre',
    'festes',
    'circ',
    'nadal',
    'fires-i-mercats',
    'rutes-i-visites',
    'cursos',
    'dansa',
    'festivals-i-mostres',
    'activitats-virtuals',
    'exposicions'
    //agar tots els tipus
    //Ponte la ventana categoría en el main y ejecuta, te saldrá un listado con todas
  ];

  _ListaMisActividadesState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    activitats = controladorPresentacion.getActivitatsUser();
    squery = '';
    _selectedCategory = 'activitats-virtuals';
    display_list = activitats;
    selectedData = '';
  }

  @override
  void initState() {
    super.initState();
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

  void searchMyActivities(String squery) async {
    //do this
    //Festa Major de Sant Vicenç
    display_list = await _controladorPresentacion.searchMyActivitats(squery);
    setState(() {});
  }

  void canviFiltreData(String date) {
    // Parse the input date string into a DateTime object
    DateTime selectedDate = DateTime.parse(date);

    // Update the state based on the filtered data
    setState(() {
      display_list = activitats.where((activity) {
        if (activity.dataInici != 'No disponible') {
          DateTime activityDate = DateTime.parse(activity.dataInici);
          return activityDate.isAfter(selectedDate) ||
              activityDate.isAtSameMomentAs(selectedDate);
        } else {
          return false;
        }
      }).toList();
    });
  }

  void filterActivitiesByCategory(String category) async {
    //si no funciona fer back

    setState(() {
      display_list = activitats
          .where((activity) => activity.categoria.contains(category))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Mis actividades"),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                  child: TextField(
                    //cercador
                    onChanged: (text) => changeSquery(text),
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(240, 186, 132, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search...",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          //FUNCIÓN
                          searchMyActivities(squery);
                        },
                        icon: Icon(Icons.search),
                      ),
                      suffixIconColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(children: [
                  SizedBox(
                    //filtre categoria
                    height: 30.0,
                    width: 200.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 200,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 170, 102, 0.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: DropdownButton<String>(
                              //dropdown en si
                              value: _selectedCategory,
                              items: llistaCategories.map((String item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  _selectedCategory = newValue;
                                  filterActivitiesByCategory(newValue!);
                                });
                              },
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor: Color.fromRGBO(255, 170, 102, 0.5),

                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                              iconSize: 20,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              underline: Container(),
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                      //filtre data
                      height: 30.0,
                      width: 110.0,
                      child: Align(
                          alignment: Alignment.center,
                          child: Container(
                              width: 500.0,
                              child: TextField(
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  controller: _dateController,
                                  decoration: const InputDecoration(
                                      labelText: 'Data',
                                      labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(255, 170, 102, 0.5),
                                      prefixIcon: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange))),
                                  readOnly: true,
                                  onTap: () {
                                    _selectDate();
                                  }))))
                ]),
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
                      //Actualizar BD + 1 Visualitzacio
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
                      padding: const EdgeInsets.all(8.0), // Adjust as needed
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 32.0, right: 16.0, left: 16.0),
                          child: Column(
                            children: [
                              Row(children: [
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
                                          color: Colors.orange),
                                    ),
                                  ),
                                )
                              ]),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(children: [
                                      SizedBox(
                                          child: Image.network(
                                        activitat.imageUrl,
                                        fit: BoxFit.cover,
                                      ))
                                    ]),
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
                                                CrossAxisAlignment
                                                    .start, // Add this line
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
                                              Text("  Inicio: ${() {
                                                try {
                                                  return DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          activitat.dataInici));
                                                } catch (e) {
                                                  return 'Unknown';
                                                }
                                              }()}")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_month),
                                              Text("  Fin: ${() {
                                                try {
                                                  return DateFormat(
                                                          'yyyy-MM-dd')
                                                      .format(DateTime.parse(
                                                          activitat.dataFi));
                                                } catch (e) {
                                                  return 'Unknown';
                                                }
                                              }()}")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.local_atm),
                                              TextWithLink(
                                                  text: "  Compra aqui",
                                                  url: activitat.urlEntrades
                                                      .toString()),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              width: 50,
                                              child: ImageCategory(
                                                  categoria:
                                                      getCategoria(activitat)))
                                        ],
                                      ))
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
          )
        ]));
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_picked);
      setState(() {
        _dateController.text = formattedDate;
        canviFiltreData(formattedDate);
      });
    }
  }
}
