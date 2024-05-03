import 'package:culturapp/translations/AppLocalizations';
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
        color: const Color(0xFFF4692A),
        activeColor: const Color(0xFFF4692A),
        tabBackgroundColor: Colors.grey.shade100,
        gap: 6,
        onTabChange: (index) {
          onTabChange(index);
        },
        selectedIndex: currentIndex,
        tabs: [
          GButton(
            text: "map".tr(context),
            textStyle: TextStyle(fontSize: 12, color: const Color(0xFFF4692A)),
            icon: Icons.map,
          ),
          GButton(
            text: "my_activities".tr(context),
            textStyle: TextStyle(fontSize: 12, color: const Color(0xFFF4692A)),
            icon: Icons.event,
          ),
          GButton(
            text: "chats".tr(context),
            textStyle: TextStyle(fontSize: 12, color: const Color(0xFFF4692A)),
            icon: Icons.chat,
          ),
          GButton(
            text: "profile".tr(context),
            textStyle: TextStyle(fontSize: 12, color: const Color(0xFFF4692A)),
            icon: Icons.person,
          ),
        ],
      ),
    );
  }
}
