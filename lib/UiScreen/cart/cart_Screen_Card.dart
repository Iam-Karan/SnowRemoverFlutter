import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:snow_remover/models/cart_model.dart';
import 'package:snow_remover/store/counter.dart';

import 'Cart_Screen.dart';

class cartScreenCard extends StatefulWidget {
  final int hours;
  final String id;
  final String image;
  final String name;
  final double price;
  final int quantity;
  final String type;

  @override
  State<cartScreenCard> createState() => _cartScreenCardState();

  const cartScreenCard({
    required this.hours,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.type,
  });
}

String value = "";

class _cartScreenCardState extends State<cartScreenCard> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    int simpleIntInput =
        widget.type.compareTo("products") == 0 ? widget.quantity : widget.hours;

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
              return Container(
                height: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(top: 25),
                    title: Text(
                      widget.name,
                      style: GoogleFonts.sora(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      )),
                    ),
                    subtitle: Center(
                      child: Column(
                        children: [
                          // Container(height: 15, child: Row()),
                          Text(
                            (() {
                              if (widget.type == "products") {
                                return "Quantity";
                              }
                              return "Number of hours";
                            })(),
                            style: GoogleFonts.sora(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey)),
                          ),
                          QuantityInput(
                            value: simpleIntInput,
                            onChanged: (value) => setState(
                              () {
                                updateCartState(simpleIntInput,
                                    int.parse(value), widget.type);
                                simpleIntInput =
                                    int.parse(value.replaceAll(',', ''));
                                updateQuantity(simpleIntInput);
                              },
                            ),
                            elevation: 2,
                          ),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl!),
                      radius: screenHeight < 550 ? 25 : 40,
                    ),
                    trailing: ElevatedButton.icon(
                      label: const Text(""),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 0,
                          splashFactory: InkSplash.splashFactory,
                          alignment: Alignment.center),
                      onPressed: () {
                        deleteIteamInCart();
                      },
                    ),
                  ),
                ),
              );
            }
        }
      }),
      future: generateImageUrl3(widget.image, widget.type),
    );
  }

  deleteIteamInCart() {
    context.read<Counter>().deleteItem(widget.id, widget.quantity);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      String? uid = user?.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(widget.id)
          .delete();
    });
  }

  updateQuantity(int quantity) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? users = auth.currentUser;
    final uid = users?.uid;
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(widget.id)
        .update(widget.type.compareTo("products") == 0
            ? {'quantity': quantity}
            : {'hours': quantity});
  }

  updateCartState(int prev, int valInt, String type) {
    CartModel item = CartModel(
        hours: widget.hours,
        id: widget.id,
        image: widget.image,
        name: widget.name,
        price: widget.price,
        quantity: widget.quantity,
        type: widget.type);
    if (prev - valInt < 0) {
      context.read<Counter>().addItem(valInt - prev, item);
    } else if (prev - valInt > 0) {
      context.read<Counter>().removeItem(prev - valInt, item.id, item.type);
    }
  }
}

Future<String> generateImageUrl3(String imageName, String type) async {
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  String downloadURL = await storage.ref(imageName).getDownloadURL();
  return downloadURL;
}
