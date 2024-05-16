import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/user_info.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:culturapp/widgetsUtils/bnav_bar.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final bool owner;
  final List<Actividad> activitatsVenc;
  final Usuari user;

  const PerfilPage(
      {Key? key,
      required this.controladorPresentacion,
      required Usuari this.user,
      required bool this.owner,
      required this.activitatsVenc})
      : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState(
      this.controladorPresentacion, this.user, this.owner, this.activitatsVenc);
}

class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 3;
  late ControladorPresentacion _controladorPresentacion;
  late Usuari _user;
  late bool _owner;
  List<String> originalUsers = [];
  List<String>users = [];
  late List<Actividad> activitatsVencidas;
  bool _isLoading = false;

  _PerfilPageState(ControladorPresentacion controladorPresentacion, Usuari user,
      bool owner, List<Actividad> vencidas) {
    _controladorPresentacion = controladorPresentacion;
    _user = user;
    _owner = owner;
    activitatsVencidas = vencidas;
  }

  @override
  void initState() {
    super.initState();
    updateUsers();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _controladorPresentacion.mostrarMapa(context);
        break;
      case 1:
        _controladorPresentacion.mostrarActividadesUser(context);
        break;
      case 2:
        _controladorPresentacion.mostrarXats(context, "Amics");
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  Future<void> updateUsers() async {
    setState(() {
      _isLoading = true;
    });
    final pendents = await widget.controladorPresentacion.getFollowUsers(_user.nom, 'pending');
    setState(() {
      users = pendents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? const Center(child: CircularProgressIndicator(color: Color(0xFFF4692A), backgroundColor: Colors.white,)
      ) : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4692A),
        title: Text(
          'profile'.tr(context),
          style: const TextStyle(color: Colors.white),
        ),
        actions: _owner
            ? [
              IconButton(
                onPressed: () {
                  _controladorPresentacion.mostrarPendents(context);
                },
                icon: Stack(
                  children: <Widget>[
                    const Icon(Icons.notifications, color: Colors.white),
                    if (users.isNotEmpty) const Positioned(  // draw a red circle as a badge
                      top: -1.0,
                      right: -1.0,
                      child: Icon(Icons.brightness_1, size: 12.0, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
                IconButton(
                  onPressed: () {
                    _controladorPresentacion.mostrarEditPerfil(
                        this.context, _user.nom);
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    _controladorPresentacion.mostrarSettings(context);
                  },
                  icon: const Icon(Icons.settings, color: Colors.white),
                ),
              ]
            : [],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Expanded(
        child: UserInfoWidget(
          controladorPresentacion: _controladorPresentacion,
          user: _user,
          owner: widget.owner,
          activitatsVencidas: activitatsVencidas,
        ),
      ),
    );
  }
}
