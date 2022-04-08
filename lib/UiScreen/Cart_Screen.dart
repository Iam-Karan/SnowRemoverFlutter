import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/cart_Screen_Card.dart';

import '../models/Generate_Image_Url.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}
   FirebaseAuth auth = FirebaseAuth.instance ;
 User? users = auth.currentUser;
final uid = users?.uid;


bool signIn = false;

class _CartScreenState extends State<CartScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        signIn = false;
      } else {
        signIn = true;
      }
    });



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 5,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cart ",
              ),
              WidgetSpan(
                child: Icon(Icons.shopping_cart, size: 35),
              ),
            ],
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
            )),
          ),
        ),
        shadowColor: Colors.yellow,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (signIn == false ) {
            return Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  "assets/images/cart.jpg",
                )
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                "Your cart is empty",
                style: GoogleFonts.sora(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                "Looks alike you haven't added \n anything to cart ",
                style: GoogleFonts.sora(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey)),
              ),
            ]);
          } else if(signIn == true && snapshot.hasData == true )  {
            return Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return cartScreenCard(
                        hours: data['hours'],
                        id: data['id'].toString(),
                        image: data['image'].toString(),
                        name: data['name'].toString(),
                        price: data['price'],
                        quantity: data['quantity'],
                        type: data['type'].toString());
                  }).toList(),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Reserve Now"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Checkout"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontStyle: FontStyle.italic),
                  ),
                )
              ]),
            ]);
          }
          return Text("jhsdcvbhjk");
        },
      ),
    );
  }
}
