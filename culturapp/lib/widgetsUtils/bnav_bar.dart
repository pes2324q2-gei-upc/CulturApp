import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
      ),
      child: GNav(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.white,
        color: Colors.orange,
        activeColor: Colors.orange,
        tabBackgroundColor: Colors.grey.shade100,
        gap: 6,
        onTabChange: (index) {
          onTabChange(index);
        },
        selectedIndex: currentIndex,
        tabs: const [
          GButton(
            text: "Mapa",
            textStyle: TextStyle(fontSize: 12, color: Colors.orange),
            icon: Icons.map,
          ),
          GButton(
            text: "Mis Actividades",
            textStyle: TextStyle(fontSize: 12, color: Colors.orange),
            icon: Icons.event,
          ),
          GButton(
            text: "Chats",
            textStyle: TextStyle(fontSize: 12, color: Colors.orange),
            icon: Icons.chat,
          ),
          GButton(
            text: "Perfil",
            textStyle: TextStyle(fontSize: 12, color: Colors.orange),
            icon: Icons.person,
          ),
        ],
      ),
    );
  }
}
