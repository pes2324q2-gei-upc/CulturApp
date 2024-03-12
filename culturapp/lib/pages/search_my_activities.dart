import "package:flutter/material.dart";

class SearchMyActivities extends StatefulWidget {
  const SearchMyActivities({Key? key}) : super(key: key);

  @override
  State<SearchMyActivities> createState() => _SearchMyActivitiesState();
}

class _SearchMyActivitiesState extends State<SearchMyActivities> {
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
                )
              ]),
        ));
  }
}
