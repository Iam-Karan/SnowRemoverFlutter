import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snow_remover/UiScreen/order/orderHistoryCard.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:snow_remover/utility.dart' as utility;
import '../cart/Cart_Screen.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  utility.SignOut(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                ),
                icon: Icon(Icons.login),
                label: Text("Log out"))
          ],
          centerTitle: true,
          title: Text("Order details"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .snapshots(includeMetadataChanges: true),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data?.docs.length != 0) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return orderHistoryCard(
                        data: data, image: "", uid: '', orderId: document.id);
                  }).toList(),
                );
              }
              return Center(
                child: Text("There is no order to display"),
              );
            }));
  }
}
