
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:snow_remover/UiScreen/order/order_screenDetail_listTile.dart';

import '../admin/Admin_feedback_dialog.dart';
import 'Feedback/feedback.dart';

class orderHistoryCard extends StatefulWidget {
  Map<String, dynamic> data;
  String image;
  String uid;
  String orderId;

  @override
  State<orderHistoryCard> createState() => _orderHistoryCardState();

  orderHistoryCard(
      {Key? key,
      required this.data,
      required this.image,
      required this.uid,
      required this.orderId})
      : super(key: key);
}

String image = "";

getDateFormated(Map<String, dynamic> data, String type) {
  var newFormat = DateFormat("yy-MM-dd   hh:mm  aaa");
  DateTime date = DateTime.parse(data[type].toDate().toString());
  var strToDateTime = DateTime.parse(date.toString());
  final convertLocal = strToDateTime.toLocal();
  String updatedDt = newFormat.format(convertLocal);
  return updatedDt;
}

class _orderHistoryCardState extends State<orderHistoryCard> {
 bool admin = false;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user?.email == "admin@email.com") {
         admin = true;
      } else {
        admin = false;
      }
    });



    int iteamCounter = widget.data['items'].length;
    var total = widget.data['total'].toStringAsFixed(1);
    String id = widget.data['items'][0]['id'];
    var number = Random().nextInt(4);

    return FutureBuilder<String>(
      builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator(
              color: Colors.yellow,
              strokeWidth: 1,
            );
          default:
            if (snapshot.hasError) {
              return Text(
                'Error cch: ${snapshot.error}',
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              );
            }

            else {
              String? imageUrl = snapshot.data;
              return InkWell(
                splashColor: Colors.yellow,
                onTap: () {
                  showDialogBox(
                      context,
                      widget.data,
                      getDateFormated(widget.data, "order_date"),
                      getDateFormated(widget.data, "reservation_datetime"),
                      widget.uid,
                      widget.orderId,
                      iteamCounter);
                },

                child: SingleChildScrollView(

                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(2),
                            title: Row(children: [
                             Text(
                                "Order ",
                               style: GoogleFonts.montserrat(
                                   textStyle: TextStyle(
                                     fontSize: MediaQuery.of(context).size.width > 400 ? 22 : 18,
                                     fontWeight: FontWeight.w500,
                                   )),
                              ),
                              Text(
                                '#' + widget.orderId,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width > 380 ? 14 : 10,
                                        fontWeight: FontWeight.w500,
                                       )),
                              ),
                            ]),
                            subtitle: Text(
                              getDateFormated(widget.data, "order_date"),
                              style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )),
                            ),
                            trailing: CircleAvatar(
                              backgroundImage:
                                  Image.asset(getImage(number)).image,
                              radius: 40,
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                            indent: 15,
                            endIndent: 15,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Column(children: [
                                      Text(
                                        "X" + iteamCounter.toString() + " iteams",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey)),
                                      ),
                                      Text("\$" + total,
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle: FontStyle.italic)))
                                    ])
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 380 ? 160 : 100,
                                ),
                               Row(

                                  children: [

                                    ElevatedButton.icon(
                                      onPressed: () {
                                        !admin  ?
                                        showDialog(
                                            context: context,
                                            builder: (context) => FeedbackDialog(
                                                  id: widget.orderId,
                                                ))

                                        : showDialog(
                                            context: context,
                                            builder: (context) => adminFeedbackDialog(
                                              id: widget.orderId,
                                            )) ;
                                      },
                                      icon: Icon(
                                        admin ?
                                        Icons.add_alert:  Icons.reviews,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      label: Text(
                                        admin ? "Check review" : "Review",
                                        style: GoogleFonts.jetBrainsMono(
                                            textStyle: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  color: Colors.green))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        }
      }),
      //future: generateImageUrl(image),
    );
  }

  String getImage(int number) {
    return "assets/images/cartoon$number.jpg";
  }

  showDialogBox(context, Map<String, dynamic> data, String updateDt,
      String reserveDate, String uid, String orderId, int iteamCounter) {
    var Title = GoogleFonts.pacifico(
        textStyle: TextStyle(
            fontWeight: FontWeight.w100, fontSize: 17, color: Colors.white));
    var Value = GoogleFonts.sora(
        textStyle: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white));

    return showDialog<void>(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomCenter,
                          colors: [
                            // Colors.blue,
                            Colors.blueAccent,
                            Colors.redAccent,
                          ],
                        )),
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Order Detail",
                              style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Id =>",
                                    style: Title,
                                  ),
                                  Text(
                                    orderId,
                                    style: Value,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date =>",
                                    style: Title,
                                  ),
                                  Text(
                                    updateDt,
                                    style: Value,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Address =>",
                                    style: Title,
                                  ),
                                  Text(
                                    "10104 place meilleur",
                                    style: Value,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status =>",
                                    style: Title,
                                  ),
                                  Text(
                                    "Complete",
                                    style: Value,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Date =>",
                                    style: Title,
                                  ),
                                  Text(
                                    reserveDate,
                                    style: Value,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: ListView.builder(
                              padding: EdgeInsets.all(5),
                              itemCount: iteamCounter,
                              itemBuilder: (context, index) {
                                return OrderScreenListTile(
                                  image: data['items'][index]['imageUrl'],
                                  name: data['items'][index]['name'],
                                  price: data['items'][index]['price'],
                                  quantity: data['items'][index]['quantity'],
                                );
                              },
                            ),
                          ),
                        ),
                        // OrderScreenListTile(image: ""),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
