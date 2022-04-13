



import 'package:flutter/material.dart';

import 'package:snow_remover/UiScreen/home_screen_redo.dart';
import 'package:snow_remover/UiScreen/order_history.dart';

import '../UiScreen/About us/aboutus_screen.dart';
import '../UiScreen/service_screen.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
    orderHistory(),
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
      body: Center(child:_widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: ConvexAppBar(
         backgroundColor : constant.primaryColor,

elevation: 10,
top: -8,
        // style: TabStyle.flip,
          color: Colors.white,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.person, title: 'Services'),
            TabItem(icon: Icons.menu, title: 'menu'),
            TabItem(icon: Icons.more_vert, title: ''),

          ],
          initialActiveIndex: 0,//optional, default as 0
          onTap: (int i) =>  _onItemTapped(i),


        )

     /* body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
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
      ),*/
    );
  }
}
