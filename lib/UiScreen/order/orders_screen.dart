import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/cart/Cart_Screen.dart';

import 'orderHistoryCard.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

var number = 0;
String image = "imageUrl";

class _OrderScreenState extends State<OrderScreen> {
  String uid = "";
  String name = " User";
  late Future futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchUser();
  }

  Future fetchUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    uid = firebaseUser.uid;
    if (uid.isNotEmpty) {
      DocumentSnapshot ds =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      name = ds.get('firstName');
    }
  }

  void goToScreen() {
    if (uid.isEmpty) {
      Navigator.pushNamed(context, '/SignIn');
    } else {
      Navigator.pushReplacementNamed(context, '/UserProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>.empty(growable: true);

    children.add(_buildBackground());

    children.add(_buildCard());

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      String? uid = user?.uid;
    });
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          primary: true,
          backgroundColor: Color(0xFF34A8DB),
          elevation: 0,
          leading: GestureDetector(
            onTap: goToScreen,
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 30.0,
              ),
            )
          ],
        ),
        body: Stack(children: children));
  }

  Widget _buildCard() {
    return uid.isNotEmpty
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('order')
                .snapshots(includeMetadataChanges: true),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.length != 0) {
                return Container(
                  margin: EdgeInsets.only(top: 60),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(1),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return orderHistoryCard(
                        data: data,
                        image: '',
                        uid: uid,
                        orderId: document.id,
                      );
                    }).toList(),
                  ),
                );
              } else {
                return Column(children: [
                  SizedBox(
                    height: 160,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Image.asset(
                        "assets/images/dribbble_shot_hd-order.png",
                        fit: BoxFit.none,
                      ))
                ]);
              }
            })
        : Column(children: [
            SizedBox(
              height: 180,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width * 1,
                child: Image.asset(
                  "assets/images/dribbble_shot_hd-order.png",
                  fit: BoxFit.none,
                ))
          ]);
  }

  Widget _buildBackground() => new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            // centerTitle: true,
            primary: true,
            backgroundColor: Color(0xFF34A8DB),
            elevation: 5,
            flexibleSpace: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              FutureBuilder(
                future: futureAlbum,
                builder: (context, snapshot) {
                  return Column(children: [
                    Row(children: [
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Good afternoon,",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize:  MediaQuery.of(context).size.width > 380 ? 22 : 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        )),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                          fontSize:  MediaQuery.of(context).size.width > 380 ? 22 : 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    ]),
                  ]);
                },
              ),
            ]),
          ),
        ),
      );
}
