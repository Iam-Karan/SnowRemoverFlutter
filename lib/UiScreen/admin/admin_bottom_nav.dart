import 'package:flutter/material.dart';
import 'package:snow_remover/UiScreen/admin/admin_contact_messages.dart';
import 'package:snow_remover/UiScreen/admin/admin_home.dart';
import 'package:snow_remover/UiScreen/admin/admin_orders.dart';
import 'package:snow_remover/UiScreen/admin/admin_service.dart';
import 'package:snow_remover/constant.dart' as constant;

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({Key? key}) : super(key: key);

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomeScreen(),
    AdminServiceScreen(),
    AdminOrders(),
    AdminFeedback()
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
            icon: Icon(Icons.list_alt_rounded),
            label: 'Orders',
            backgroundColor: constant.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
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
