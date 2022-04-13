import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/utility.dart' as utility;
class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
            onTap: () => utility.SignOut(context),
            child: Container(
              height: 40,
              width: 80,
              decoration: const BoxDecoration(color: constant.primaryColor),
              alignment: Alignment.center,
              child: Text(
                isLoggedIn ? "Logout" : "Login",
                textAlign: TextAlign.justify,
              ),
            )));
  }
}
