import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';

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
  late List<String> requests;
  late List<String> difference;
  late bool isFollows;
  late TabController _tabController;
  bool _isLoading = false;

  _LlistarFollowsState() {
    users = [];
  }

  Future<void> updateUsers() async {

    setState(() {
      _isLoading = true;
    });
      late List<String> followers;
      late List<String> followings;

      followers = await widget.controladorPresentacion.getFollowUsers(widget.username, "followers"); 
      followings = await widget.controladorPresentacion.getFollowUsers(widget.username, "following"); 
      requests = await widget.controladorPresentacion.getRequestsUser();

      Set<String> followersSet = Set.from(followers);
      Set<String> followingsSet = Set.from(followings);
      Set<String> requestsSet = Set.from(requests);

      followersSet = followersSet.difference(followingsSet);
      difference = followersSet.difference(requestsSet).toList();

      if(mounted) {
        setState(() {
          users = isFollows ? followers : followings;
          _isLoading = false;
        });
      }
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
    isFollows = widget.follows;
    updateUsers();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.follows ? 0 : 1;
    _tabController.addListener(() {
      doAsyncWork();
    });
  }

  void doAsyncWork() async {
    await updateUsers();
    if (mounted) {
      setState(() {
        isFollows = _tabController.index == 0;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? Center(child: CircularProgressIndicator(color: const Color(0xFFF4692A), backgroundColor: Colors.white,)
      ):Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: Text("friends_title".tr(context)),
        centerTitle: true,
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso
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
              child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), 
                  ),
                ],
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search'.tr(context),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    updateList(value);
                  },
                ),
              ),
            ),
            ),
          ),
        const SizedBox(height: 20),
        Expanded(
          child: RefreshIndicator(
            onRefresh: updateUsers,
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
                        ? (difference.contains(users[index]) ? "followerNotFollowed" : (requests.contains(users[index])) ? "followerRequestSend" : "followerFollowed") 
                        : "following", 
                      popUpStyle: "default",
                      placeReport: "null",
                      controladorPresentacion: widget.controladorPresentacion,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
