import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';

class UserInfoWidget extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final String username;
  final bool owner;

  const UserInfoWidget(
      {Key? key,
      required this.controladorPresentacion,
      required this.username,
      required this.owner})
      : super(key: key);

  @override
  _UserInfoWidgetState createState() =>
      _UserInfoWidgetState(this.controladorPresentacion);
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  int _selectedIndex = 0;
  late ControladorPresentacion _controladorPresentacion;
  late String _usernameFuture;
  late List<Actividad> activitats;
  late List<Actividad> display_list;

  _UserInfoWidgetState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
    _usernameFuture = widget.username;
    activitats = widget.owner ? _controladorPresentacion.getActivitatsUser() : [];
    display_list = activitats;
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getLabelText(int index) {
    switch (index) {
      case 0:
        return 'Historico actividades';
      case 1:
        return 'Insignias o logros';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String?>(
          future: Future.value(_usernameFuture),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(
                    color: Color(0xFFF4692A)),
              );
            } else if (snapshot.hasError) {
              return const Text('Error al obtener el nombre de usuario');
            } else {
              final username = snapshot.data ?? '';
              return _buildUserInfo(username);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 25, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: NetworkImage(
                            _controladorPresentacion.getUser()!.photoURL!),
                        fit: BoxFit.cover),
                  )),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '1500 XP',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _buildInfoColumn("assisted_events".tr(context), '1'),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: GestureDetector(
                  onTap: () {
                    widget.controladorPresentacion.mostrarFollows(context, true);
                  },
                  child: _buildInfoColumn('followers'.tr(context), '12'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: GestureDetector(
                  onTap: () {
                    widget.controladorPresentacion.mostrarFollows(context, false);
                  },
                  child: _buildInfoColumn('following'.tr(context), '40'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "assisted_events".tr(context)),
                    Tab(text: "badges".tr(context)),
                  ],
                  indicatorColor: const Color(0xFFF4692A),
                  labelColor: const Color(0xFFF4692A),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            SizedBox(
                              height: 450,
                              child: ListaActividadesDisponibles(
                                actividades: activitats,
                                controladorPresentacion: _controladorPresentacion,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text("Insignias"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
