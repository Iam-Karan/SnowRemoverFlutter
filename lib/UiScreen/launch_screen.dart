import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snow_remover/constant.dart';
import 'package:snow_remover/utility.dart' as utility;

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        color: primaryColor,
        child: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 200.0,
                height: 200.0,
                child: Image(
                  image: AssetImage('assets/images/SnowRemoverLogo.png'),
                ),
              ),
              Text(
                "Snow Remover",
                style: TextStyle(
                    fontSize: 36.0,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        )),
      ),
    );
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    DocumentSnapshot? userInfo = await utility.fetchUser();
    if (userInfo != null &&
        userInfo.get("type").toString().toLowerCase() == "admin") {
      Navigator.pushReplacementNamed(context, '/admin_bottomnav');
      // signed in
    } else {
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    }
  }
}
