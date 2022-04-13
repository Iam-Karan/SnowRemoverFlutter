import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snow_remover/UiScreen/cart/Cart_Screen.dart';
import 'package:snow_remover/UiScreen/orderHistoryCard.dart';

class orderHistory extends StatefulWidget {
  const orderHistory({Key? key}) : super(key: key);

  @override
  State<orderHistory> createState() => _orderHistoryState();
}
var number = 0;
String image = "imageUrl";
class _orderHistoryState extends State<orderHistory> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      String? uid = user?.uid;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("OrderHistory"),
      ),
      body: StreamBuilder(
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
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              children: snapshot.data!.docs.map((document) {

                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                print(data);
                return orderHistoryCard(image: "",);
              }).toList(),
            );
          }),
    );
  }
}
