import 'package:flutter/material.dart';
import 'package:snow_remover/utility.dart' as utility;
import 'package:snow_remover/constant.dart' as constant;

class ProductCard extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String cardImage;
  final String supportingText;
  final String id;
  final double price;
  final String brand;

  const ProductCard(
      {Key? key,
      required this.heading,
      required this.subHeading,
      required this.cardImage,
      required this.supportingText,
      required this.id,
      required this.price,
      required this.brand})
      : super(key: key);

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
                'Error: ${snapshot.error}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              );
            } else {
              String? imageUrl = snapshot.data;
              return Card(
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
                  child:  Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.18,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Image(
                              image: NetworkImage(imageUrl!),
                              width: MediaQuery.of(context).size.height * 0.35,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                            Text(
                              brand ,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "   \$" + price.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14.0,
                              ),
                            ),
                            ]
                          )
                        ],
                      ),
                    ),
                //  ],
              //  ),
              );
            }
        }
      }),
      future: utility.generateImageUrl(cardImage),
    );
  }
}
