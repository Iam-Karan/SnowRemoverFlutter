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
  @protected
  @mustCallSuper
  void initState() {
    fetchUser();
  }

  fetchUser() async {

    await Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        final firebaseUser =  FirebaseAuth.instance.currentUser!;
         FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get()
            .then((ds) {
          name = ds.data()!["firstName"];
          uid = firebaseUser.uid;
        }).catchError((e) {
          print(e);
        });
      });
    });

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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: GotoScreen,
          child: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 30.0,
          ),
        ),
        title: Text(name),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30.0,
            ),
          )
        ],
        elevation: 0,
      ),
    );
  }
}
