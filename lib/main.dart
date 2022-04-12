import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/UiScreen/Cart_Screen.dart';
import 'package:snow_remover/UiScreen/admin/admin_add_product.dart';
import 'package:snow_remover/UiScreen/admin/admin_bottom_nav.dart';
import 'package:snow_remover/UiScreen/admin/admin_feedback.dart';
import 'package:snow_remover/UiScreen/admin/admin_home.dart';
import 'package:snow_remover/UiScreen/admin/admin_service.dart';
import 'package:snow_remover/UiScreen/checkout_screen.dart';
import 'package:snow_remover/UiScreen/sign_In.dart';
import 'package:snow_remover/UiScreen/aboutus_screen.dart';
import 'package:snow_remover/components/bottom_navigator.dart';
import 'package:snow_remover/UiScreen/launch_screen.dart';
import 'package:snow_remover/UiScreen/orders_screen.dart';
import 'package:snow_remover/UiScreen/service_screen.dart';
import 'package:snow_remover/UiScreen/sign_Up.dart';
import 'package:snow_remover/UiScreen/user_profile.dart';
import 'Colors/ThemeColor.dart';
import 'constant.dart' as constant;
import 'package:firebase_core/firebase_core.dart';

void main() async {
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
          '/SignUp': (context) => const SignUp(),
          '/UserProfile': (context) => const UserProfile(),
          '/admin_bottomnav': (context) => const AdminBottomNav(),
          '/admin_home': (context) => const AdminHomeScreen(),
          '/admin_service': (context) => const AdminServiceScreen(),
          '/admin_feedback': (context) => const AdminFeedback(),
          '/add_edit_product': (context) => const AddEditProduct(),
          '/cartScreen': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF34A8DB)),
          colorScheme: const ColorScheme.light()
              .copyWith(primary: constant.primaryColor),
        ),
      ),
    );
  }
}
