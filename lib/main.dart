import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/UiScreen/sign_In.dart';
import 'package:snow_remover/UiScreen/aboutus_screen.dart';
import 'package:snow_remover/UiScreen/bottom_navigator.dart';
import 'package:snow_remover/UiScreen/launch_screen.dart';
import 'package:snow_remover/UiScreen/orders_screen.dart';
import 'package:snow_remover/UiScreen/service_screen.dart';
import 'package:snow_remover/UiScreen/sign_Up.dart';
import 'Colors/ThemeColor.dart';
import 'constant.dart' as constant;
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Snow Remover',
        initialRoute: '/',
        routes: {
          '/': (context) => const LaunchScreen(),
          'aboutus': (context) => const AboutUs(),
          '/bottom_nav': (context) => const BottomNav(),
          '/service_screen': (context) => const ServiceScreen(),
          '/order_screen': (context) => const OrderScreen(),
          '/SignIn': (context) => const SignIn(),
          '/SignUp': (context) => SignUp(),
        },
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF34A8DB)),
          colorScheme:
              const ColorScheme.light().copyWith(primary: constant.primaryColor),
        ),
      ),
    );
  }
}
