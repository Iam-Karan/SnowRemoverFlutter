import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/utility.dart' as utility;

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({Key? key}) : super(key: key);

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
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
