import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LlistarFollows extends StatefulWidget {
  final String username;
  final ControladorPresentacion controladorPresentacion;
  final bool follows;
  const LlistarFollows({super.key, required this.controladorPresentacion, required this.username, required this.follows});

  @override
  _LlistarFollowsState createState() => _LlistarFollowsState();
}

class _LlistarFollowsState extends State<LlistarFollows> with SingleTickerProviderStateMixin {
  late List<String> users;
  late List<String> difference;
  late bool isFollows;
  late TabController _tabController;

  _LlistarFollowsState() {
    users = [];
  }

  void updateUsers() async {
      late List<String> followers;
      late List<String> followings;
      late List<String> requests;

      followers = await widget.controladorPresentacion.getFollowUsers(widget.username, "followers"); 
      followings = await widget.controladorPresentacion.getFollowUsers(widget.username, "following"); 
      requests = await widget.controladorPresentacion.getRequestsUser();

      Set<String> followersSet = Set.from(followers);
      Set<String> followingsSet = Set.from(followings);
      Set<String> requestsSet = Set.from(requests);

      followersSet = followersSet.difference(followingsSet);
      difference = followersSet.difference(requestsSet).toList();

      setState(() {
        users = isFollows ? followers : followings;
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
    _tabController.index = widget.follows ? 0 : 1;
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
        title: Text("friends_title".tr(context)),
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
          const SizedBox(height: 16.0),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "followers".tr(context)),
              Tab(text: "following".tr(context)),
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
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 10.0),
                  userBox(
                    text: users[index], 
                    recomm: false, 
                    type: isFollows 
                      ? (difference.contains(users[index]) ? "addSomeone" : "null") 
                      : "null", 
                    controladorPresentacion: widget.controladorPresentacion,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
