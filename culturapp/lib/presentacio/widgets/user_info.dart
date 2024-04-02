import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoWidgetState createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  String _selectedText = 'Historico actividades';
  int _selectedIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedText = _getLabelText(index);
    });
  }

  //texto que aparece al apretar uno de los botones
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
    //faltaria adaptar el padding en % per a cualsevol dispositiu
    //columna para la parte del username, xp i imagen perfil
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom:20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //imagen
            children: [
              Image.asset(
                'assets/userImage.png',
                width: 100, 
                height: 100, 
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //username
                    Text(
                      'Username',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    //XP
                    Text(
                      'XP',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              //edit username
              Transform.translate(
                offset: const Offset(0, 5),
                child: Transform.scale(
                  scale: 0.9, 
                  child: IconButton(
                    onPressed: () {
                      //hacer que no se vea si estas viendo el perfil de otro user
                      //Navigator.pushNamed(context, Routes.updatePerfil);
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
        //contenedor para elegir ver el historico o las insignias
        Container(
          height: 50,
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.event_available, 'Historico actividades', 0),
              _buildNavItem(Icons.stars, 'Insignias', 1),
            ],
          ),
        ),
        //Texto de historico o insignias
        const SizedBox(height: 10),
        Center(
          child: Text(
            _selectedText, 
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
  
  //NavItem de historico o insignias
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        _onTabChange(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.orange : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}