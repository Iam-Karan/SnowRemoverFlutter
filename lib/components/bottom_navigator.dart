import 'package:flutter/material.dart';
import 'package:snow_remover/UiScreen/home_screen_redo.dart';
import 'package:snow_remover/UiScreen/orders_screen.dart';
import '../UiScreen/aboutus_screen.dart';
import '../UiScreen/service_screen.dart';
import 'package:snow_remover/constant.dart' as constant;

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    // HomeScreen(),
    HomeScreenTwo(),
    ServiceScreen(),
    OrderScreen(),
    AboutUs(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: constant.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Service',
            backgroundColor: constant.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Orders',
            backgroundColor: constant.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: '',
            backgroundColor: constant.primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
