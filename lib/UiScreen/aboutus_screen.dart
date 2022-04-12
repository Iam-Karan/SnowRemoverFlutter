import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/FeedBack.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                      "i am rich kjlwefnwenfjsdnfmsdfj;snfvkjsDNKJVb:VBsdBNViu;dsKNVUInSDUIVNksDNVkjznjkvnjsnvksdnbvkjsvjkdbviskbksfilasbvilsbvuoafbvikdsfbvilksfbvilkdfabvouyilbfxulhvjbafuoLJBVauoydflhflkdnvjnsVKJN"
                      "ijfvbkjnVjiknzdijkvnijKNVjkladfnkvo;lkSNVi;dnfvoi;lcNVI:jkfznv o;klc"
                      "iufdsBVLXikbvilkBFViLKBJVLhjBLDHFKBVILKDFV ZJKf"
                      "jfhlkvblHBVlikfbvilhakfvdilkvf"
                      "kbvil",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontSize: 16,
                             // fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54))),
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
      )
    );
  }
}
