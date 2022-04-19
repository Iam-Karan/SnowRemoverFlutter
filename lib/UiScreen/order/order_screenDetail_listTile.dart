import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/Product_Display.dart';

class OrderScreenListTile extends StatefulWidget {
  String image;
  String name;
  double price;
  String quantity;

  @override
  State<OrderScreenListTile> createState() => _OrderScreenListTileState();

  OrderScreenListTile(
      {required this.image,
      required this.name,
      required this.price,
      required this.quantity});
}



class _OrderScreenListTileState extends State<OrderScreenListTile> {

  @override
  Widget build(BuildContext context) {
    var Title1 = GoogleFonts.sora(
        textStyle: TextStyle(
            fontWeight: FontWeight.w700, fontSize:  MediaQuery.of(context).size.width > 380 ? 20 : 14 , color: Colors.white));
    var subTitle1 = GoogleFonts.sora(
        textStyle: TextStyle(
            fontWeight: FontWeight.w500, fontSize: MediaQuery.of(context).size.width > 380 ? 14 : 10, color: Colors.white));
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
              return InkWell(

                onTap: () {

                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.2),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!, scale: 10),
                    radius: MediaQuery.of(context).size.width > 380 ? 40 : 30,
                  ),
                  title: Text(
                    widget.name,
                    style: Title1,
                  ),
                  subtitle: Text(
                    "\$" + widget.price.toString(),
                    style: subTitle1,
                  ),
                  trailing: Text(
                    "Qty:" + widget.quantity,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width > 380 ? 18 : 14),
                  ),
                ),
              );
            }
        }
      }),
      future: generateImageUrl(widget.image),
    );
  }
}

Future<String> generateImageUrl(String imageName) async {
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  String downloadURL = await storage.ref(imageName).getDownloadURL();
  return downloadURL;
}
