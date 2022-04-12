import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/FeedBack.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF92dbe6), Color(0xFF34A8DB)])),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 1,
            ),
            Positioned(
              top: 70,
              left: 30,
              right: 30,
              child: Image.asset(
                "assets/images/Rectangle 27.png",
                width: 400,
                fit: BoxFit.contain,
              ),
            ),
          ]),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "    About us",
                style: GoogleFonts.pacifico(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                        color: Colors.blue)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 180,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Text(
                    "Snow removal appliocation was built to make your life easier.\n"
                    " We give you everything you need to clean your way to reach out your destionation in snow season"
                    "We're here to help you. You can use our equipments according to thier need.Also, "
                    "hire experienced person to remove snow.Our primary approach to solve your snow problem."
                    "You can easily access our app at any time and use facilities accordingly.Year after year, we continue to expand and improve our facilities to meet the needs of our users",
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            fontSize: 16,
                             fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87))),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "    FeedBack Form",
                style: GoogleFonts.pacifico(
                    textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                        color: Colors.blue)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const feedback()
        ],
      ),
    ));
  }
}
