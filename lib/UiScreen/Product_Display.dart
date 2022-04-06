import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:snow_remover/models/cartModel.dart';
import 'package:like_button/like_button.dart';
import 'package:snow_remover/utility.dart' as utility;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../components/toast_message/ios_Style.dart';

class productDisplay extends StatefulWidget {
  String video_url;
  String brand;
  String description;
  double price;
  String image;
  String ID;

  @override
  State<productDisplay> createState() => _productDisplayState();

  productDisplay(
      {required this.video_url,
      required this.brand,
      required this.description,
      required this.price,
      required this.image,
      required this.ID});
}

bool tapped = false;

class _productDisplayState extends State<productDisplay> {
  String productPrice = "";
  late YoutubePlayerController _controller;
  int simpleIntInput = 0;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.video_url)!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    productPrice = (widget.price).toString();
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
                              tapped
                                  ? Image(
                                      image: NetworkImage(imageUrl!),
                                      fit: BoxFit.contain,
                                      height: 220,
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                    )
                                  : YoutubePlayer(
                                      controller: _controller,
                                      showVideoProgressIndicator: true,
                                    ),
                              //videoPlayer(),
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
                                    LikeButton(
                                      onTap: onLikeButtonTapped,
                                      size: 60,
                                      animationDuration:
                                          const Duration(seconds: 2),
                                    ),
                                  ],
                                  verticalDirection: VerticalDirection.down,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                SizedBox(height: 8),
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
                                                    fontSize: 24,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                      ]),
                                      Row(children: [
                                        SizedBox(width: 15),
                                        Text("Quantity:  ",
                                            style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    fontSize: 24,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                addIteamToCart();
                                              });
                                            },
                                            icon: Icon(Icons.add_shopping_cart),
                                            label: Text("Cart"),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
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
        future: utility.generateImageUrl(widget.image),
      ),
    );
  }

  addIteamToCart() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      String? uid = user?.uid;

      if (user == null) {
        showOverlay((context, t) {
          return Opacity(
            opacity: t,
            child: IosStyleToast(label: "User is not sign in"),
          );
        });
      } else {
        cartModel C = cartModel();
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .where('name', isEqualTo: widget.brand)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            if (simpleIntInput != 0) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection("cart")
                  .doc(widget.brand)
                  .set({
                'id': uid,
                'image': widget.image,
                'name': widget.brand,
                'quantity': simpleIntInput,
                'type': "product",
              });
              showOverlay((context, t) {
                return Opacity(
                  opacity: t,
                  child: IosStyleToast(label: "iteam added to cart"),
                );
              });
            } else {
              showOverlay((context, t) {
                return Opacity(
                  opacity: t,
                  child: IosStyleToast(label: "please choose quantity"),
                );
              });
            }
          } else {
            addCartToDocumentId(uid!);
          }
        });
      }
    });
  }

  addCartToDocumentId(String uid) {
    if (simpleIntInput != 0) {
      final databaseReference = FirebaseFirestore.instance;
      databaseReference
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(widget.brand)
          .set({
        'id': uid,
        'image': widget.image,
        'name': widget.brand,
        'quantity': simpleIntInput,
        'type': "product",
      });
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: "iteam added to cart"),
        );
      });
    } else {
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: "please add quantity"),
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
        .doc(widget.brand)
        .set({
      'id': uid,
      'value': true,
      'type': "product",
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (isLiked == false) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        String? uid = user?.uid;
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
                  .doc(widget.brand)
                  .set({
                'id': uid,
                'value': true,
                'type': "product",
              });
            } else {
             addFavorite(uid!);
            }
          });
      });
      return !isLiked;
    } else {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        String? uid = user?.uid;
        FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('favorite')
            .doc(widget.brand)
            .delete();
      });
    }
    return !isLiked;
  }
}
