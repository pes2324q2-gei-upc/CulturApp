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
  const Xats(
      {super.key,
      required this.controladorPresentacion,
      required this.recomms,
      required this.usersBD});
  @override
  State<Xats> createState() => _Xats(controladorPresentacion, recomms, usersBD);
}

class _Xats extends State<Xats> {
  late ControladorPresentacion _controladorPresentacion;
  int _selectedIndex = 2;
  late List<Usuario> usersRecom;
  late List<Usuario> usersBD;
  //List<Actividad> activitats = null; quan tinguem de base de dades fer-ho bé
  late Widget currentContent;

  _Xats(ControladorPresentacion controladorPresentacion, List<Usuario> recomms,
      List<Usuario> usBD) {
    _controladorPresentacion = controladorPresentacion;
    currentContent = AmicsScreen(
      controladorPresentacion: _controladorPresentacion,
    );

    usersRecom = recomms;
    usersBD = usBD;
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
        _controladorPresentacion.mostrarXats(context);
        break;
      case 3:
        _controladorPresentacion.mostrarPerfil(context);
        break;
      default:
        break;
    }
  }

  Color _buttonAmics = Colors.grey;
  Color _buttonGrups = const Color(0xFFF4692A);
  Color _buttonAfegirAmics = const Color(0xFFF4692A);

  void _changeButtonColor(int buttonNumber) {
    setState(() {
      if (buttonNumber == 1) {
        _buttonAmics = Colors.grey;
        _buttonGrups = const Color(0xFFF4692A);
        _buttonAfegirAmics = const Color(0xFFF4692A);
      } else if (buttonNumber == 2) {
        _buttonAmics = const Color(0xFFF4692A);
        _buttonGrups = Colors.grey;
        _buttonAfegirAmics = const Color(0xFFF4692A);
      } else if (buttonNumber == 3) {
        _buttonAmics = const Color(0xFFF4692A);
        _buttonGrups = const Color(0xFFF4692A);
        _buttonAfegirAmics = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF4692A),
        title: Text(
          'chats'.tr(context),
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 50.0,
                      width: 120.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(_buttonAmics),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          _changeButtonColor(1);
                          changeContent(AmicsScreen(
                            controladorPresentacion: _controladorPresentacion,
                          ));
                        },
                        child: Text('friends'.tr(context)),
                      )),
                  SizedBox(
                      height: 50.0,
                      width: 120.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(_buttonGrups),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          _changeButtonColor(2);
                          changeContent(
                            GrupsScreen(
                              controladorPresentacion: _controladorPresentacion,
                            ),
                          );
                        },
                        child: Text('groups'.tr(context)),
                      )),
                  SizedBox(
                      height: 50.0,
                      width: 120.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              _buttonAfegirAmics),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          _changeButtonColor(3);
                          changeContent(AfegirAmics(
                            recomms: usersRecom,
                            usersBD: usersBD,
                            controladorPresentacion: _controladorPresentacion,
                          ));
                        },
                        child: Text('add_friends'.tr(context)),
                      )),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                child: Column(
                  children: [currentContent],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
