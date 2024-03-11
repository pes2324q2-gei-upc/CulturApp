
import 'dart:convert';
import 'package:culturapp/actividades/actividad.dart';
import 'package:culturapp/routes/routes.dart';
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

  Future<List<Actividad>> fetchActivities() async {
    var url = Uri.parse("https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    var response = await http.get(url);

    var actividades = <Actividad>[];
    
    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        actividades.add(Actividad.fromJson(actividadJson));
      }
    }
    return actividades;
  }
  @override
  void initState() {
    super.initState();
    fetchActivities().then((value) {
      setState(() {
        _actividades.addAll(value);
      });
    });
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
      body: ListView.builder(
        itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, right: 16.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      Text(
                      _actividades[index].name ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),
                      ),
                    Text(
                      _actividades[index].code ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600
                      ),

                      ),
                  ],
                ),
              ),
            );
          },
          itemCount: _actividades.length,
      ),
    );
  }
}