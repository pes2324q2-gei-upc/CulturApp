//import "package:culturapp/presentacio/routes/routes.dart";
import "package:culturapp/domain/models/user.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/screens/afegir_amics.dart";
import "package:culturapp/presentacio/screens/xats/amics/amics_screen.dart";
import "package:culturapp/presentacio/screens/xats/grups/grups_screen.dart";
import "package:culturapp/translations/AppLocalizations";
import "package:culturapp/widgetsUtils/bnav_bar.dart";
import "package:flutter/material.dart";

class Xats extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final List<Usuario> recomms;
  final List<Usuario> usersBD;
  final String pagina;
  const Xats(
      {super.key,
      required this.controladorPresentacion,
      required this.recomms,
      required this.usersBD,
      required this.pagina});
  @override
  State<Xats> createState() =>
      _Xats(controladorPresentacion, recomms, usersBD, pagina);
}

class _Xats extends State<Xats> {
  late ControladorPresentacion _controladorPresentacion;
  late int _selectedIndex;
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  late Widget currentContent;

  _Xats(ControladorPresentacion controladorPresentacion, List<Usuario> recomms,
      List<Usuario> usBD, String pagina) {
    _controladorPresentacion = controladorPresentacion;
    currentContent = AmicsScreen(
      controladorPresentacion: _controladorPresentacion,
    );

    usersRecom = recomms;
    usersBD = usBD;

    _loadIndex(pagina);
  }

  void _loadIndex(String pagina) {
    if (pagina == "Grups") {
      _selectedIndex = 1;
    } else if (pagina == "Amics") {
      _selectedIndex = 2;
    } else {
      //Afegir Amics
      _selectedIndex = 3;
    }
  }

  void changeContent(Widget newContent) {
    setState(() {
      currentContent = newContent;
    });
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF4692A),
          title: const Text(
            'Comunidad',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'friends'.tr(context)),
              Tab(text: 'groups'.tr(context)),
              Tab(text: 'add_friends'.tr(context)),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AmicsScreen(
                  controladorPresentacion: _controladorPresentacion,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GrupsScreen(
                  controladorPresentacion: _controladorPresentacion,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AfegirAmics(
                  recomms: usersRecom,
                  usersBD: usersBD,
                  controladorPresentacion: _controladorPresentacion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
