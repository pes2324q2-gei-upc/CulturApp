//import "package:culturapp/presentacio/routes/routes.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/screens/afegir_amics.dart";
import "package:culturapp/presentacio/screens/amics.dart";
import "package:culturapp/widgetsUtils/bnav_bar.dart";
import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";

class Xats extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  const Xats({super.key, required this.controladorPresentacion});
  @override
  State<Xats> createState() => _Xats(controladorPresentacion);
}

class _Xats extends State<Xats> {
  late ControladorPresentacion _controladorPresentacion;
  int _selectedIndex = 2; 
  //List<Actividad> activitats = null; quan tinguem de base de dades fer-ho bé
  Widget currentContent = Amics();
  
  _Xats(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
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
  Color _buttonGrups = Colors.orange;
  Color _buttonAfegirAmics = Colors.orange;

  void _changeButtonColor(int buttonNumber) {
    setState(() {
      if (buttonNumber == 1) {
        _buttonAmics = Colors.grey;
        _buttonGrups = Colors.orange;
        _buttonAfegirAmics = Colors.orange;
      } else if (buttonNumber == 2) {
        _buttonAmics = Colors.orange;
        _buttonGrups = Colors.grey;
        _buttonAfegirAmics = Colors.orange;
      } else if (buttonNumber == 3) {
        _buttonAmics = Colors.orange;
        _buttonGrups = Colors.orange;
        _buttonAfegirAmics = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: const Text(
          'Xats',
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
                            changeContent(Amics());
                          },
                          child: Text('Amics'),
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
                            changeContent(Grups());
                          },
                          child: Text('Grups'),
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
                            changeContent(AfegirAmics());
                          },
                          child: Text('Afegir Amics'),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: currentContent,
                ),
              ]),
        ),
      ),
    );
  }
}

class Grups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('This is Grups');
  }
}
