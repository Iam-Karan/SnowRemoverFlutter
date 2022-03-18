import 'package:flutter/material.dart';
import 'package:snow_remover/constant.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 200.0,
              child: const Image(
                image: AssetImage('assets/images/SnowRemoverLogo.png'),
              ),
            ),
            const Text(
              "Snow Remover",
              style: TextStyle(
                  fontSize: 48.0,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacementNamed(context, '/bottom_nav');
  }
}
