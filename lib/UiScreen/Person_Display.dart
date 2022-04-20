import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:snow_remover/models/cart_model.dart';
import 'package:snow_remover/store/counter.dart';
import '../components/toast_message/ios_Style.dart';
import '../models/Generate_Image_Url.dart';

class personDisplay extends StatefulWidget {
  String brand;
  String description;
  double price;
  String image;
  String id;

  @override
  State<personDisplay> createState() => _personDisplayState();

  personDisplay({
    required this.brand,
    required this.description,
    required this.price,
    required this.image,
    required this.id,
  });
}

bool tapped = false;

class _personDisplayState extends State<personDisplay> {
  String productPrice = "";

  int simpleIntInput = 1;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? users = auth.currentUser;
    String? uid = users?.uid;

    bool isliked = false;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot querySnapshot) async {
      if (querySnapshot.exists) {
        print("jhxbc");
        isliked = true;
      } else {
        isliked;
      }
    });

    productPrice = (widget.price.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text("Details",
            style: GoogleFonts.roboto(
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 24))),
      ),
      body: FutureBuilder<String>(
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
                return Container(
                  color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Container(
                          //color: Colors.blue,
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Stack(
                            children: [
                              Image(
                                image: NetworkImage(imageUrl!),
                                fit: BoxFit.contain,
                                height: 220,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 1,
                              ),
                              Positioned(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tapped = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.circle,
                                    color: tapped ? Colors.red : Colors.white,
                                  ),
                                ),
                                bottom: 20,
                                left: ((MediaQuery.of(context).size.width * 1 -
                                        50) /
                                    2),
                              ),
                              Positioned(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tapped = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.circle,
                                    color: tapped ? Colors.white : Colors.red,
                                  ),
                                ),
                                bottom: 20,
                                left: ((MediaQuery.of(context).size.width * 1) /
                                    2),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: 600,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(90)),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(2),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.brand,
                                      style: GoogleFonts.commissioner(
                                          textStyle: TextStyle(
                                              fontSize: 36,
                                              color: Color(0xff34A8DB),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(width: 50),
                                    uid == null
                                        ? SizedBox(width: 5)
                                        : LikeButton(
                                            isLiked: isliked,
                                            onTap: onLikeButtonTapped,
                                            size: 60,
                                            animationDuration:
                                                const Duration(seconds: 2),
                                          ),
                                  ],
                                  verticalDirection: VerticalDirection.down,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 120,
                                  child: Text(
                                    widget.description,
                                    style: GoogleFonts.sora(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal)),
                                  ),
                                  margin: EdgeInsets.all(10),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        SizedBox(width: 15),
                                        Text(
                                            "Price:  \$" + productPrice + "/Hr",
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width > 380 ? 24 : 16,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                      ]),
                                      Row(children: [
                                        SizedBox(width: 15),
                                        Text("Number of hours:  ",
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width > 380 ? 24 : 16,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                        QuantityInput(
                                          value: simpleIntInput,
                                          onChanged: (value) => setState(() =>
                                              simpleIntInput = int.parse(
                                                  value.replaceAll(',', ''))),
                                          elevation: 2,
                                        ),
                                      ]),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              addIteamToCart();
                                            },
                                            icon: Icon(Icons.add_shopping_cart),
                                            label: Text("Cart"),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              minimumSize: Size(200, 2),
                                              padding: EdgeInsets.all(7)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          }
        }),
        future: generateImageUrl2(widget.image),
      ),
    );
  }

  addIteamToCart() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? users = auth.currentUser;
    String? uid = users?.uid;

    if (users == null) {
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: "User is not sign in"),
        );
      });
    } else {
      CartModel cartItem;
      int totalHours = 0;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(widget.id)
          .get()
          .then((DocumentSnapshot docSnapshot) async {
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data()! as Map<String, dynamic>;
          if (simpleIntInput != 0) {
            totalHours = simpleIntInput + int.parse(data['hours'].toString());
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection("cart")
                .doc(widget.id)
                .set({
              'id': widget.id,
              'image': "personimages/" + widget.image,
              'name': widget.brand,
              'hours': totalHours,
              'type': "personimages",
              'price': widget.price,
              'quantity': 1,
            });
            showOverlay((context, t) {
              return Opacity(
                opacity: t,
                child: IosStyleToast(label: "person added to cart"),
              );
            });
          } else {
            showOverlay((context, t) {
              return Opacity(
                opacity: t,
                child: IosStyleToast(label: "please choose hour"),
              );
            });
          }
        } else {
          totalHours = simpleIntInput;
          addCartToDocumentId(uid!);
        }
        cartItem = CartModel(
            hours: totalHours,
            id: widget.id,
            image: "personimages/" + widget.image,
            name: widget.brand,
            price: widget.price,
            quantity: 1,
            type: "personimages");
        if (mounted) {
          context.read<Counter>().addItem(totalHours, cartItem);
        }
      });
    }
  }

  addCartToDocumentId(String uid) {
    if (simpleIntInput != 0) {
      final databaseReference = FirebaseFirestore.instance;
      databaseReference
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(widget.id)
          .set({
        'id': widget.id,
        'image': "personimages/" + widget.image,
        'name': widget.brand,
        'hours': simpleIntInput,
        'type': "personimages",
        'price': widget.price,
        'quantity': 1,
      });
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: "person added to cart"),
        );
      });
    } else {
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: "please add hours"),
        );
      });
    }
  }

  addFavorite(String uid) {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .doc(widget.id)
        .set({
      'id': widget.id,
      'type': "product",
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (isLiked == false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? users = auth.currentUser;
      String? uid = users?.uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorite')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('favorite')
              .doc(widget.id)
              .set({
            'id': widget.id,
            'type': "products",
          });
        } else {
          addFavorite(uid!);
        }
      });
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? users = auth.currentUser;
      String? uid = users?.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorite')
          .doc(widget.id)
          .delete();
    }
    return !isLiked;
  }
}
