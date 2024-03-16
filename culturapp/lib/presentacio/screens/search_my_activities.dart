import "package:culturapp/domain/filtre_data.dart";
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
  static List<Actividad> my_activities_list = [];
  Future<void>? _fetchMyActivitiesFuture;

  Future<void> fetchMyActivities() async {
    //var activities = await getActivities();
    var activities = [
      Actividad(
          name: "Super3",
          code: "AABB",
          categoria: "infantil",
          latitud: 2.0,
          longitud: 3.0,
          imageUrl:
              "https://i.pinimg.com/originals/10/ef/0c/10ef0c804190d04cace0f0096ccb8912.jpg",
          descripcio: "descripcio",
          dataInici: "10-07-2024",
          dataFi: "23-07-2024",
          ubicacio: "ubicacio",
          urlEntrades: Uri(),
          preu: "preu",
          comarca: "comarca",
          horari: "horari"),
      Actividad(
          name: "Super31",
          code: "AACC",
          categoria: "teatre",
          latitud: 2.0,
          longitud: 3.0,
          imageUrl:
              "https://i.pinimg.com/originals/10/ef/0c/10ef0c804190d04cace0f0096ccb8912.jpg",
          descripcio: "descripcio",
          dataInici: "10-08-2024",
          dataFi: "23-08-2024",
          ubicacio: "ubicacio",
          urlEntrades: Uri(),
          preu: "preu",
          comarca: "comarca",
          horari: "horari"),
      Actividad(
          name: "ConcertTaylor",
          code: "AACC",
          categoria: "concert",
          latitud: 2.0,
          longitud: 3.0,
          imageUrl:
              "https://i.pinimg.com/originals/10/ef/0c/10ef0c804190d04cace0f0096ccb8912.jpg",
          descripcio: "descripcio",
          dataInici: "30-11-2024",
          dataFi: "23-12-2024",
          ubicacio: "ubicacio",
          urlEntrades: Uri(),
          preu: "preu",
          comarca: "comarca",
          horari: "horari"),
    ];
    setState(() {
      my_activities_list = activities;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMyActivitiesFuture = fetchMyActivities();
  }

  //creant la llista que farem display i aplicarem els seus filtres:
  List<Actividad> display_list = List.from(my_activities_list);

  String selectedCategory = '';
  String value = '';

  void updateList(String value, String category) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {
        display_list = my_activities_list
            .where((element) =>
                element.name.toLowerCase().contains(value.toLowerCase()) &&
                (category == '' || element.categoria == category))
            .toList();
      },
    );
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
                  onChanged: (value) => updateList(value, selectedCategory),
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
                    suffixIcon: const Icon(Icons.search),
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
                    child: FiltreCategoria(canviCategoria: (newFilter) {
                      setState(() {
                        selectedCategory = newFilter;
                      });
                      updateList(value, selectedCategory);
                    }),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: FiltreData(),
                  )
                ]),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) => ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(display_list[index].name,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(display_list[index].categoria,
                                style: const TextStyle(color: Colors.orange)),
                            trailing: Text("${display_list[index].preu}",
                                style: TextStyle(color: Colors.orange)),
                            leading:
                                Image.network(display_list[index].imageUrl!),
                          )),
                ),
              ]),
        ));
  }
}
