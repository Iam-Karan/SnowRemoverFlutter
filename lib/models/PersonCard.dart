import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/scale_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../UiScreen/Person_Display.dart';
import './Generate_Image_Url.dart';

class personCard extends StatelessWidget {
  final String heading;
  final String cardImage;
  final String name;
  final int id;
  final double price;

  const personCard({
    Key? key,
    required this.heading,
    required this.cardImage,
    required this.name,
    required this.id,
    required this.price,
  }) : super(key: key);

  void SelectedRoute(BuildContext ctx) {
    Navigator.of(ctx).push(PageAnimationTransition(
        page: personDisplay(
          brand: name,
          description: heading,
          price: price,
          image: cardImage,
        ),
        pageAnimationType: ScaleAnimationTransition()));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text(
                'Error h: ${snapshot.error}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              );
            } else {
              String? imageUrl = snapshot.data;
              return InkWell(
                onTap: () => SelectedRoute(context),
                hoverColor: Colors.yellow,
                splashColor: Colors.yellow,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  elevation: 5,
                  // child: Column(
                  //   children: [
                  // SizedBox(
                  //   height: screenHeight * 0.20,
                  //   width: screenWidth * 0.20,
                  //   child: Image(
                  //     image: NetworkImage(imageUrl!),
                  //   ),
                  // ),
                  child: Expanded(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(imageUrl!),
                            // width: MediaQuery.of(context).size.height * 0.35,
                            //  height: MediaQuery.of(context).size.height * 0.15,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                "   \$" + price.toString(),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.0,
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                  //  ],
                  //  ),
                ),
              );
            }
        }
      }),
      future: generateImageUrl2(cardImage),
    );
  }
}
