import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _auth = FirebaseAuth.instance;
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
    if(!uid.isEmpty){
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      name = ds.get('firstName');
    }

  }

  void GotoScreen() {
    if (uid.isEmpty) {
      Navigator.pushReplacementNamed(context, '/SignIn');
    } else {
      Navigator.pushReplacementNamed(context, '/UserProfile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text("Shop tools")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 70.0,
            color: Color(0xFF34A8DB),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: GotoScreen,
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
                      onTap: () {},
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
    );
  }
}
