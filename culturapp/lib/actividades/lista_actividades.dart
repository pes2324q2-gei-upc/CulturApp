
import 'dart:convert';
import 'package:culturapp/actividades/actividad.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:culturapp/widgetsUtils/image_category.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

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
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchActivitiesFuture = fetchActivities();
  }
  
  void _onTabChange(int index) {
    // Aquí puedes realizar acciones específicas según el índice seleccionado
    // Por ejemplo, mostrar un mensaje diferente para cada tab
    switch (index) {
      case 0:
      Navigator.pop(context);
      Navigator.pushNamed(context, Routes.map);
        break;
      case 1:
        break;
      case 2:
        Navigator.pop(context);

        break;
      case 3:
        Navigator.pop(context);

        break;

      default:
        break;
    }
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
        onTabChange: (index) {
          _onTabChange(index);
        },
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
                    padding: EdgeInsets.all(8.0), // Adjust as needed
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, right: 16.0, left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _actividades[index].name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  height: 30,
                                  child: ImageCategory(categoria: "${_actividades[index].categoria}"),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Card(
                                    color: Colors.green.shade300, 
                                    child: Column(
                                      children: [
                                        Text(
                                          "  ${_actividades[index].comarca}  ",
                                          style: const TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
                            Image.network("${_actividades[index].imageUrl}"),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add your left button logic here
                                },
                                child: Text("More"),
                              )
                            )
                          ],
                        ),
                      ),
                    )
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