import "package:culturapp/domain/models/user.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:flutter/material.dart";

class AfegirAmics extends StatefulWidget {
  @override
  final List<Usuario> recomms;
  final List<Usuario> usersBD;
  final ControladorPresentacion controladorPresentacion;

  const AfegirAmics(
      {super.key,
      required this.recomms,
      required this.controladorPresentacion,
      required this.usersBD,});

  @override
  State<StatefulWidget> createState() => _AfegirAmicsState(recomms, usersBD);
}

class _AfegirAmicsState extends State<AfegirAmics> {
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  late  List<String>requests;
  bool isLoading = true;

  _AfegirAmicsState(List<Usuario> recomms, List<Usuario> usBD)  {
    usersRecom = recomms;
    usersBD = usBD;
  }

  String value = '';

  Color taronjaVermellos = const Color(0xFFF4692A);
  Color taronjaVermellosFluix = const Color.fromARGB(199, 250, 141, 90);

  void updateList(String newValue) {
    setState(() {
      value = newValue;
      usersBD = widget.usersBD
          .where((user) =>
              user.username.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    updateUsers().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> updateUsers() async {
    requests = await widget.controladorPresentacion.getRequestsUser();
  }

  @override
  Widget build(BuildContext context) {
      return isLoading 
        ? const Center(heightFactor: 12,child: CircularProgressIndicator(color: Color(0xFFF4692A),),) 
        : Column(
      children: [
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
                fillColor: taronjaVermellosFluix,
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
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
              ),
            ),
          ),
        ),
        SizedBox(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              if (value == "" || value == " ") ...[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "recommendations".tr(context),
                    style: TextStyle(
                      color: taronjaVermellos,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                for (var user in usersRecom)
                if (!requests.contains(user.username)) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: userBox(
                        text: user.username,
                        recomm: true,
                        type: "addSomeone",
                        popUpStyle: "default",
                        placeReport: "null",
                        controladorPresentacion:
                            widget.controladorPresentacion),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: userBox(
                        text: user.username,
                        recomm: true,
                        type: "requested",
                        popUpStyle: "default",
                        placeReport: "null",
                        controladorPresentacion:
                            widget.controladorPresentacion),
                  ),
                ],
              ] else ...[
                for (var user in usersBD)
                 if (!requests.contains(user.username)) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: userBox(
                        text: user.username,
                        recomm: false,
                        type: "addSomeone",
                        popUpStyle: "default",
                        placeReport: "null",
                        controladorPresentacion:
                            widget.controladorPresentacion),
                  ),
                 ],
              ]
            ],
          ),
        ),
      ],
    );
  }
}
