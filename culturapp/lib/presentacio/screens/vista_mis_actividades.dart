import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaMisActividades extends StatefulWidget {
  
  final ControladorPresentacion controladorPresentacion;

  ListaMisActividades({super.key, required this.controladorPresentacion,});

  @override
  State<ListaMisActividades> createState() => _ListaMisActividadesState(controladorPresentacion,);
}

class _ListaMisActividadesState extends State<ListaMisActividades> {
  late List<Actividad> activitats;
  late ControladorPresentacion _controladorPresentacion;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _ListaMisActividadesState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    activitats = controladorPresentacion.getActivitatsUser();
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange,
      title: const Text("Mis actividades"),
    ),
    body: ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            List<String> act = [
              activitats[index].name,
              activitats[index].code,
              activitats[index].categoria[0],
              activitats[index].imageUrl,
              activitats[index].descripcio,
              activitats[index].dataInici,
              activitats[index].dataFi,
              activitats[index].ubicacio
            ];
            _controladorPresentacion.mostrarVerActividad(
              context, 
              act, 
              activitats[index].urlEntrades
            );
            //Actualizar BD + 1 Visualitzacio
              DocumentReference docRef = _firestore
              .collection('actividades')
                  .doc(activitats[index].code);
              await _firestore
                  .runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(docRef);
                int currentValue = 0;
                if (snapshot.data() is Map<String, dynamic>) {
                  currentValue = (snapshot.data() as Map<String,
                          dynamic>)['visualitzacions'] ??
                      5;
                }
                int newValue = currentValue + 1;
                transaction.update(
                    docRef, {'visualitzacions': newValue});
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
                            activitats[index].name,
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
                          child: Column(
                            children: [
                              SizedBox(
                                child: Image.network(
                                  activitats[index].imageUrl,
                                  fit: BoxFit.cover,
                                )
                              )
                            ]
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start, // Add this line
                                  children: [
                                    const Icon(Icons.location_on),
                                    Expanded(
                                      child: Text(
                                        "  ${activitats[index].ubicacio}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    Text("  Inicio: ${() {
                                      try {
                                        return DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                activitats[index].dataInici));
                                      } catch (e) {
                                        return 'Unknown';
                                      }
                                    }()}"
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    Text("  Fin: ${() {
                                      try {
                                        return DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                activitats[index].dataFi));
                                      } catch (e) {
                                        return 'Unknown';
                                      }
                                    }()}"
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.local_atm),
                                    TextWithLink(text: "  Compra aqui",
                                      url: activitats[index].urlEntrades.toString()),
                                  ],
                                )
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
                                  categoria: getCategoria(activitats[index])
                                )
                              )
                            ],
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: activitats.length,
    ),
  );
}
}