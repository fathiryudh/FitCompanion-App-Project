import 'package:flutter/material.dart';
import 'about.dart';
import 'home.dart';
import 'locator.dart';
import 'tracker.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  int _currentindex = 0;
  final tabs = [HomePage(), AddFoodIntakeScreen(), Locator(), About()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: tabs[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF99C24D),
          unselectedItemColor: Color(0xFF2E4057),
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentindex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: "Dashboard",
              icon: Icon(Icons.dashboard_outlined),
            ),
            BottomNavigationBarItem(
              label: "Tracker",
              icon: Icon(Icons.food_bank_outlined),
            ),
            BottomNavigationBarItem(
              label: "Locator",
              icon: Icon(Icons.location_on_outlined),
            ),
            BottomNavigationBarItem(
              label: "About",
              icon: Icon(Icons.extension_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
