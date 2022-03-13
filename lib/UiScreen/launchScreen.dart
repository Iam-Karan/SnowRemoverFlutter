import 'package:flutter/material.dart';
import 'package:snow_remover/constant.dart';
class LauchScreen extends StatelessWidget {
  const LauchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 200.0,
              child: Image(
                image: AssetImage('assets/images/SnowRemoverLogo.png'),
              ),
            ),
            Text("Snow Remover",
              style: TextStyle(
                fontSize: 48.0,
                color: SecondaryColor,
                fontWeight: FontWeight.bold
              ),)
          ],
        ),
      ),
    );
  }
}
