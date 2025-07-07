import 'package:flutter/material.dart';
import 'package:hadirin_app/constant/app_color.dart';
import 'package:hadirin_app/screen/main_screen/history_screen.dart';
import 'package:hadirin_app/screen/main_screen/home_screen.dart';
import 'package:hadirin_app/screen/main_screen/maps_screen.dart';
import 'package:hadirin_app/screen/main_screen/profile_screen.dart';

class ButtonNavbar extends StatefulWidget {
  const ButtonNavbar({super.key});

  @override
  State<ButtonNavbar> createState() => _ButtonNavbarState();
}

class _ButtonNavbarState extends State<ButtonNavbar> {
  static const List<Widget> _screen = [
    HomeScreen(),
    MapsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];
  int _buttonSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _buttonSelected = value;
          });
        },
        selectedItemColor: Color(0XFF3B3B1A),
        unselectedItemColor: Color(0XFFAEC8A4),
        currentIndex: _buttonSelected,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Pesanan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Profile"),
        ],
      ),
      body: _screen[_buttonSelected],
    );
  }
}
