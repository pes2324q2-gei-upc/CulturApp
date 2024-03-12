import "package:culturapp/domain/models/actividad.dart";
import "package:flutter/material.dart";

class SearchMyActivities extends StatefulWidget {
  const SearchMyActivities({Key? key}) : super(key: key);

  @override
  State<SearchMyActivities> createState() => _SearchMyActivitiesState();
}

class _SearchMyActivitiesState extends State<SearchMyActivities> {
  //dummy activitats fins que tinguem les de l'api
  static List<Actividad> my_activities_list = [
    Actividad(
        name: "Super3",
        code: "AABB",
        categoria: "concert",
        latitud: 2.0,
        longitud: 3.0,
        imageUrl: "imatge url",
        descripcio: "descripcio",
        dataInici: "dataInici",
        dataFi: "dataFi",
        ubicacio: "ubicacio",
        urlEntrades: Uri(),
        preu: "preu",
        comarca: "comarca",
        horari: "horari"),
    Actividad(
        name: "Super31",
        code: "AACC",
        categoria: "concert",
        latitud: 2.0,
        longitud: 3.0,
        imageUrl: "imatge url",
        descripcio: "descripcio",
        dataInici: "dataInici",
        dataFi: "dataFi",
        ubicacio: "ubicacio",
        urlEntrades: Uri(),
        preu: "preu",
        comarca: "comarca",
        horari: "horari"),
  ];

  //creant la llista que farem display i aplicarem els seus filtres:
  List<Actividad> display_list = List.from(my_activities_list);

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Search for an event",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(240, 186, 132, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(display_list[index].name,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(display_list[index].descripcio,
                                style: TextStyle(color: Colors.orange)),
                          )),
                )
              ]),
        ));
  }
}
