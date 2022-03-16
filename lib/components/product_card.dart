import 'package:flutter/material.dart';
import 'package:snow_remover/utility.dart' as utility;

class ProductCard extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String cardImage;
  final String supportingText;
  final String id;
  final String price;

  const ProductCard(
      {Key? key,
      required this.heading,
      required this.subHeading,
      required this.cardImage,
      required this.supportingText,
      required this.id,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              print("this is the image url" + imageUrl.toString());
              return Card(
                elevation: 4.0,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(heading, maxLines: 1),
                      trailing: const Icon(Icons.favorite_outline),
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Ink.image(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }
        }
      }),
      future: utility.generateImageUrl(cardImage),
    );
  }
}
