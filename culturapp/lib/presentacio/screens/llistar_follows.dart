import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LlistarFollows extends StatefulWidget {
  const LlistarFollows({Key? key}) : super(key: key);

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

  static const token = "976f2f7b53c188d8a77b9b71887621d1e1d207faec5663bf79de9572ac887ea7";

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
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> getFollowersUser(String token) async {
    return getUsers(token, 'followers');
  }

  Future<List<String>> getFollowingsUser(String token) async {
    return getUsers(token, 'following');
  }

  void updateUsers() async {
    List<String> updatedUsers;
    if (isFollows) {
      updatedUsers = await getFollowersUser(token);
    } else {
      updatedUsers = await getFollowingsUser(token);
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
        title: const Text("Amics"),
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
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Followings"),
            ],
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFollowersView(),
                _buildFollowingsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersView() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            userBox(text: users[index], recomm: false),
            const SizedBox(height: 5.0),
          ],
        );
      },
    );
  }

  Widget _buildFollowingsView() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            userBox(text: users[index], recomm: false),
            const SizedBox(height: 5.0),
          ],
        );
      },
    );
  }
}

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
      home: const LlistarFollows(),
    );
  }
}
