import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LlistarFollows extends StatefulWidget {
  final String token;
  const LlistarFollows({Key? key, required this.token}) : super(key: key);

  @override
  _LlistarFollowsState createState() => _LlistarFollowsState();
}

class _LlistarFollowsState extends State<LlistarFollows> with SingleTickerProviderStateMixin {
  late List<String> users;
  late bool isFollows;
  late TabController _tabController;

  _LlistarFollowsState() {
    users = [];
    isFollows = true;
  }

  Future<List<String>> getUsers(String token, String endpoint) async {
    final respuesta = await http.get(
      Uri.parse('http://10.0.2.2:8080/amics/Pepe/$endpoint'),
      headers: {
      'Authorization': 'Bearer $token',
      },
    );

    if (respuesta.statusCode == 200) {
      final body = respuesta.body;
      final List<dynamic> data = json.decode(body);
      final List<String> users = data.map((user) => user.toString()).toList();
      return users;
    } else {
      throw Exception('Fallo la obtención de datos' /*"data_error_msg".tr(context)*/);
    }
  }

  Future<List<String>> getFollowersUser(String token) async {
    return getUsers(widget.token, 'followers');
  }

  Future<List<String>> getFollowingsUser(String token) async {
    return getUsers(widget.token, 'following');
  }

  void updateUsers() async {
    List<String> updatedUsers;
    if (isFollows) {
      updatedUsers = await getFollowersUser(widget.token);
    } else {
      updatedUsers = await getFollowingsUser(widget.token);
    }
    setState(() {
      users = updatedUsers;
    });
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

  @override
  void initState() {
    super.initState();
    isFollows = true;
    updateUsers();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isFollows = _tabController.index == 0;
        updateUsers();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text("Amics" /*"friends_title".tr(context)*/),
        centerTitle: true,
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Followers" /*"followers".tr(context)*/),
              Tab(text: "Followings" /*"followings".tr(context)*/),
            ],
            indicatorColor: const Color(0xFFF4692A),
            labelColor: const Color(0xFFF4692A),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFollowView(),
                _buildFollowView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowView() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
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
                hintText: "Search..." /*"search".tr(context)*/,
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
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 10.0),
                  userBox(text: users[index], recomm: false, type: "deleteFollow"),
                ],
              );
            },
          ),
        ),
      ],
    );
  }}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CulturApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LlistarFollows(token: "976f2f7b53c188d8a77b9b71887621d1e1d207faec5663bf79de9572ac887ea7"),
    );
  }
}
