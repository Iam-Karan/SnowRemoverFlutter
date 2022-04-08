import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_remover/UiScreen/Cart_Screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String uid = "";
  String name = "Hi, user";
  late Future futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchUser();
  }

  Future fetchUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    uid = firebaseUser.uid;
    if(uid.isNotEmpty){
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      name = ds.get('firstName');
    }

  }

  void goToScreen() {
    if (uid.isEmpty) {
      Navigator.pushReplacementNamed(context, '/SignIn');
    } else {
      Navigator.pushReplacementNamed(context, '/UserProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF34A8DB),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 70.0,
                  color: const Color(0xFF34A8DB),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: goToScreen,
                            child: const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          )),
                      Expanded(
                          flex: 8,
                          child: FutureBuilder(
                            future: futureAlbum,
                            builder: (context, snapshot) {
                              return Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            },
                          )),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
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
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
