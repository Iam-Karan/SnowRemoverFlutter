import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/cart/cart_Screen_Card.dart';
import 'package:snow_remover/models/cart_model.dart';
import 'package:snow_remover/models/checkout_screen_args.dart';
import 'package:snow_remover/utility.dart' as utility;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<CartModel> currentCart = [];
  User? users;
  String? uid;
  bool signIn = false;

  @override
  Widget build(BuildContext context) {
    users = auth.currentUser;
    String? uid = users?.uid;
    signIn = false;

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots();

    // FirebaseAuth.instance.userChanges().listen((User? user) {
    if (users == null) {
      signIn = false;
    } else {
      signIn = true;
    }
    // });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cart ",
              ),
              WidgetSpan(
                child: utility.getAction(context)[0],
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
          // currentCart.clear();

          if (signIn == false || snapshot.data?.docs.length == 0) {
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
          } else if (signIn == true && snapshot.data?.docs.length != 0) {
            //
            return SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      CartModel curr = CartModel(
                          hours: data['hours'],
                          id: data['id'],
                          image: data['image'],
                          name: data['name'],
                          price: data['price'],
                          quantity: data['quantity'],
                          type: data['type']);
                      currentCart.add(curr);
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: reserveNow,
                        child: const Text("Reserve Now"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(6),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPrimary: Colors.white,
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontStyle: FontStyle.italic),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: checkout,
                        child: const Text("Checkout"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          padding: EdgeInsets.all(10),
                          onPrimary: Colors.white,
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ]),
              ]),
            );
          }
          return Text("there is error");
        },
      ),
    );
  }

  void checkout() {
    CheckoutArgs args = CheckoutArgs(items: currentCart);
    Navigator.pushNamed(context, '/checkout', arguments: args);
  }

  void reserveNow() {
    CheckoutArgs args = CheckoutArgs(items: currentCart);
    Navigator.pushNamed(context, '/reserve_screen', arguments: args);
  }
}
