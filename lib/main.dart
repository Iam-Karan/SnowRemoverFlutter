import 'package:flutter/material.dart';
import 'package:snow_remover/UiScreen/aboutus_screen.dart';
import 'package:snow_remover/UiScreen/bottom_navigator.dart';
import 'package:snow_remover/UiScreen/launch_screen.dart';
import 'package:snow_remover/UiScreen/orders_screen.dart';
import 'package:snow_remover/UiScreen/service_screen.dart';
import 'constant.dart' as constant;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snow Remover',
      initialRoute: '/',
      routes: {
        '/': (context) => const LaunchScreen(),
        'aboutus': (context) => const AboutUs(),
        '/bottom_nav': (context) => const BottomNav(),
        '/service_screen': (context) => const ServiceScreen(),
        '/order_screen': (context) => const OrderScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme:
            const ColorScheme.light().copyWith(primary: constant.primaryColor),
      ),
    );
  }
}
