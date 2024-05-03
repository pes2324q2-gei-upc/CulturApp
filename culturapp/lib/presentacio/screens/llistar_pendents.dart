import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';

class LlistarPendents extends StatefulWidget {
  final String username;
  final ControladorPresentacion controladorPresentacion;
  const LlistarPendents({super.key, required this.controladorPresentacion, required this.username});

  @override
  _LlistarPendentsState createState() => _LlistarPendentsState();
}

class _LlistarPendentsState extends State<LlistarPendents> {
  late List<String> users;
  late bool isFollows;

  _LlistarPendentsState() {
    users = [];
    isFollows = true;
  }

  List<String> originalUsers = [];
  
  void updateList(String value) {
    setState(() {
      if (originalUsers.isEmpty) {
        originalUsers = List.from(users);
      }
      users = originalUsers.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  void updateUsers() async {
    final pendents = await widget.controladorPresentacion.getFollowUsers(widget.username, 'pending');
    setState(() {
      users = pendents;
    });
  }

  @override
  void initState() {
    super.initState();
    updateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("friendship_requests_title".tr(context)),
        centerTitle: true, // Centrar el título
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 26.0), 
          SizedBox(
            height: 45.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: TextField(
                onChanged: (value) {
                  updateList(value);
                },
                cursorColor: Colors.white,
                cursorHeight: 20,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFAA80),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "search".tr(context),
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  suffixIcon: const Icon(Icons.search),
                  suffixIconColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5.0), 
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    userBox(
                      text: users[index], 
                      recomm: false, 
                      type: "pending", 
                      controladorPresentacion: widget.controladorPresentacion),
                    const SizedBox(height: 5.0), 
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

