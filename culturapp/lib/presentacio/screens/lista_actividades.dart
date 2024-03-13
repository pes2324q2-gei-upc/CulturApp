import 'dart:convert';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListaActividades extends StatefulWidget {
  const ListaActividades({super.key});

  @override
  State<ListaActividades> createState() => _ListaActividadesState();
}

class _ListaActividadesState extends State<ListaActividades> {



  List<Actividad> _actividades = [];
  Future<void>? _fetchActivitiesFuture;

  Future<void> fetchActivities() async {
    var url = Uri.parse("https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    var actividades = <Actividad>[];
    
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var actividadesJson = json.decode(response.body);
        for (var actividadJson in actividadesJson) {
          actividades.add(Actividad.fromJson(actividadJson));
        }
        setState(() {
          _actividades = actividades;
        });
      } 
      else {
      throw Exception('Failed to load activities');
      }
    } 
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchActivitiesFuture = fetchActivities();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Actividades Disponibles"),
      ),
      bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
      child: GNav(
        backgroundColor: Colors.white,
        color: Colors.orange,
        activeColor: Colors.orange,
        tabBackgroundColor: Colors.grey.shade100,
        gap: 6,
        selectedIndex: 1,
        tabs: const [
          GButton(text: "Mapa", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.map),
          GButton(text: "Mis Actividades", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.event),
          GButton(text: "Chats", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.chat),
          GButton(text: "Perfil", textStyle: TextStyle(fontSize: 12, color: Colors.orange), icon: Icons.person),
        ],
      ),
    ),
      body: FutureBuilder<void>(
        future: _fetchActivitiesFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                  return Container(
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
                                      _actividades[index].name,
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
                                          _actividades[index].imageUrl,
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
                                            const Icon(Icons.share_location_rounded),
                                            Expanded(
                                              child: Text(
                                                "  ${_actividades[index].ubicacio}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month_sharp),
                                            Text("  Inicio: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_actividades[index].dataInici))}")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month_sharp),
                                            Text("  Fin: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_actividades[index].dataFi))}")
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(Icons.card_giftcard),
                                            Text('  -')
                                            //Text(_actividades[index].regal ?? '-')
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(Icons.attach_money_rounded),
                                            //TextWithLink(text: "  Compra aqui", url: _actividades[index].urlEntrades),
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
                                        child: ImageCategory(categoria: _actividades[index].categoria),
                                      ),
                                    ],
                                  )
                                )
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                  );
                },
                itemCount: _actividades.length,
            );
          }
        },
      ),
    );
  }
}