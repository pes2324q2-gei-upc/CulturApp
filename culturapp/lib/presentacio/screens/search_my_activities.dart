/*import "dart:convert";
import 'package:http/http.dart' as http;
import "package:culturapp/domain/models/filtre_data.dart";
import "package:culturapp/domain/models/actividad.dart";
import "package:culturapp/domain/models/filtre_categoria.dart";
import "package:flutter/material.dart";

class SearchMyActivities extends StatefulWidget {
  const SearchMyActivities({Key? key}) : super(key: key);

  @override
  State<SearchMyActivities> createState() => _SearchMyActivitiesState();
}

class _SearchMyActivitiesState extends State<SearchMyActivities> {
  //dummy activitats fins que tinguem les de l'api
  //fins que backend no funcioni

  TextEditingController searchController = TextEditingController();
  String selectedCategoria = '';
  String selectedData = '';

  /*Future<void> fetchMyActivities(
      String searchQuery, String categoria, String data) async {
    String url =
        '/activitats/user/:id/search?q=$searchQuery&filterCategoria=$categoria&filterData=$data';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        my_activities_list =
            data.map((json) => Actividad.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load actividades');
    }
  }*/

  //borrar quan backend estigui implementat
  static List<Actividad> display_list = [];
  List<Actividad> my_activities_list = List.from(display_list); //[];

  Future<void> fetchMyActivities(
      String searchQuery, String categoria, String data) async {
    setState(() {
      my_activities_list = display_list
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
              (categoria == '' || element.categoria == categoria))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Search for an event",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: searchController,
                  onChanged: (text) =>
                      fetchMyActivities(text, selectedCategoria, selectedData),
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
                        fetchMyActivities(searchController.text,
                            selectedCategoria, selectedData);
                      },
                      icon: Icon(Icons.search),
                    ),
                    suffixIconColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(children: [
                  SizedBox(
                    height: 30.0,
                    width: 100.0,
                    child: FiltreCategoria(canviCategoria: (newCategoria) {
                      setState(() {
                        selectedCategoria = newCategoria!;
                      });
                    }),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: FiltreData(canviData: (newData) {
                      setState(() {
                        selectedData = newData!;
                      });
                    }),
                  )
                ]),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: my_activities_list.length,
                      itemBuilder: (context, index) => ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(my_activities_list[index].name,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(
                                my_activities_list[index].categoria as String,
                                style: const TextStyle(color: Colors.orange)),
                            trailing: Text("${my_activities_list[index].preu}",
                                style: TextStyle(color: Colors.orange)),
                            leading: Image.network(
                                my_activities_list[index].imageUrl!),
                          )),
                ),
              ]),
        ));
  }
}*/
