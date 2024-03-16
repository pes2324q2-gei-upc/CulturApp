import "package:culturapp/presentacio/routes/routes.dart";
import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";

class Xats extends StatefulWidget {
  const Xats({super.key});

  @override
  State<Xats> createState() => _Xats();
}

class _Xats extends State<Xats> {
  //List<Actividad> activitats = null; quan tinguem de base de dades fer-ho bé
  String containerContent = 'Content 1';

  void changeContent(String newContent) {
    setState(() {
      containerContent = newContent;
    });
  }

  void _onTabChange(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, Routes.misActividades);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.xats);
        break;
      case 3:
        Navigator.pushNamed(context, Routes.perfil);
        break;
      default:
        break;
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                              MaterialStateProperty.all<Color>(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () => changeContent('Content 1'),
                        child: Text('Amics'),
                      )),
                  SizedBox(
                      height: 50.0,
                      width: 120.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () => changeContent('Content 2'),
                        child: Text('Grups'),
                      )),
                  SizedBox(
                      height: 50.0,
                      width: 120.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () => changeContent('Content 3'),
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
                child: Text(containerContent),
              ),
            ]),
      ),
      //container amb les diferents pantalles
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        ),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.orange,
          activeColor: Colors.orange,
          tabBackgroundColor: Colors.grey.shade100,
          gap: 6,
          onTabChange: (index) {
            _onTabChange(index);
          },
          selectedIndex: 3,
          tabs: const [
            GButton(
                text: "Mapa",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.map),
            GButton(
                text: "Mis Actividades",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.event),
            GButton(
                text: "Chats",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.chat),
            GButton(
                text: "Perfil",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.person),
          ],
        ),
      ),
    );
  }
}
