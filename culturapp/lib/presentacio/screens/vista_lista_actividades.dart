import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaActividadesDisponibles extends StatefulWidget {
  final List<Actividad> actividades;
  final ControladorPresentacion controladorPresentacion;
  const ListaActividadesDisponibles({super.key, required this.actividades, required this.controladorPresentacion});

  @override
  State<ListaActividadesDisponibles> createState() => _ListaActividadesDisponiblesState(controladorPresentacion);
}

class _ListaActividadesDisponiblesState extends State<ListaActividadesDisponibles> {
  late ControladorPresentacion _controladorPresentacion;

  _ListaActividadesDisponiblesState(ControladorPresentacion controladorPresentacion){
    _controladorPresentacion = controladorPresentacion;
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
    body: ListView.builder(
      itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
            List<String> act = [
              widget.actividades[index].name,
              widget.actividades[index].code,
              widget.actividades[index].categoria[0],
               widget.actividades[index].imageUrl,
               widget.actividades[index].descripcio,
               widget.actividades[index].dataInici,
               widget.actividades[index].dataFi,
               widget.actividades[index].ubicacio
            ];
            _controladorPresentacion.mostrarVerActividad(
              context, 
              act, 
               widget.actividades[index].urlEntrades
            );
            },
             child: Container(
              padding: const EdgeInsets.all(8.0), // Adjust as needed
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 32.0, right: 16.0, left: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                widget.actividades[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange
                                ),
                              ),
                            ),
                          )
                        ]
                      ),
                      Row(
                        children: [
                          //Padding(padding: EdgeInsets.only(top: 20)),
                          //Image
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                SizedBox(
                                  //width: 100, // Take all available width
                                  //height: double.infinity, // Take all available height
                                  child: Image.network(
                                    widget.actividades[index].imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                )
                              ]
                            ),
                          ),
                          //Title, category, location, dateIni and dateFi
                          //Regal, link to buy
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                                    children: [
                                      const Icon(Icons.location_on),
                                      Expanded(
                                        child: Text(
                                          "  ${widget.actividades[index].ubicacio}",
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
                                            return DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.actividades[index].dataInici));
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
                                            return DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.actividades[index].dataFi));
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
                                      TextWithLink(text: "  Compra aqui", url: widget.actividades[index].urlEntrades.toString()),
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
                                  child: ImageCategory(categoria: getCategoria(widget.actividades[index]))
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
            )
          );
        },
        itemCount: widget.actividades.length,
      )
    );
  }
}