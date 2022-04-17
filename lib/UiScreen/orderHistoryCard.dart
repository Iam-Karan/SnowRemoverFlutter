import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
class orderHistoryCard extends StatefulWidget {
  String image;




  @override
  State<orderHistoryCard> createState() => _orderHistoryCardState();

  orderHistoryCard({
    required this.image,
  });
}

class _orderHistoryCardState extends State<orderHistoryCard> {

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    return FutureBuilder<String>(
      builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator(
              color: Colors.yellow,
              strokeWidth: 1,
            );
          default:
            if (snapshot.hasError) {
              return Text(
                'Error cch: ${snapshot.error}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              );
            } else {
              String? imageUrl = snapshot.data;
              return Card(
                child: Column(
                  children: [
                    ListTile(
                    leading:  CircleAvatar(
                      //  backgroundImage: NetworkImage(imageUrl!),
                        radius: 40,
                      ),
                    )
                  ],
                ),
              );
            }
        }
      }),
     // future: generateImageUrl(widget.image),
    );
  }
}
Future<String> generateImageUrl(String imageName) async {
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  String downloadURL = await storage.ref(imageName).getDownloadURL();
  return downloadURL;
}