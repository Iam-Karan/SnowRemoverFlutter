import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/UiScreen/admin/admin_add_person.dart';
import 'package:snow_remover/UiScreen/cart/Cart_Screen.dart';
import 'package:snow_remover/UiScreen/admin/admin_add_product.dart';
import 'package:snow_remover/UiScreen/admin/admin_bottom_nav.dart';
import 'package:snow_remover/UiScreen/admin/admin_contact_messages.dart';
import 'package:snow_remover/UiScreen/admin/admin_home.dart';
import 'package:snow_remover/UiScreen/admin/admin_service.dart';
import 'package:snow_remover/UiScreen/checkout_screen.dart';
import 'package:snow_remover/UiScreen/reserve_screen.dart';
import 'package:snow_remover/UiScreen/sign_In.dart';
import 'package:snow_remover/UiScreen/About%20us/aboutus_screen.dart';
import 'package:snow_remover/components/bottom_navigator.dart';
import 'package:snow_remover/UiScreen/launch_screen.dart';
import 'package:snow_remover/UiScreen/order/orders_screen.dart';
import 'package:snow_remover/UiScreen/service_screen.dart';
import 'package:snow_remover/UiScreen/sign_Up.dart';
import 'package:snow_remover/UiScreen/user_profile.dart';
import 'Colors/ThemeColor.dart';
import 'constant.dart' as constant;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'store/counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = constant.pKEY;
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Counter()),
  ], child: const MyApp()));
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
          '/add_person': (context) => const AdminAddPerson(),
          '/reserve_screen': (context) => const ReserveScreen()
        },
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF34A8DB)),
          colorScheme: const ColorScheme.light()
              .copyWith(primary: constant.primaryColor),
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
      ),
    );
  }
}
