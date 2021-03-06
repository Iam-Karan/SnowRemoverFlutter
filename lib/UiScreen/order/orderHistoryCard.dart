import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/order/order_screenDetail_listTile.dart';
import 'package:snow_remover/utility.dart' as utility;
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

getTodayDate() {
  DateTime time = DateTime.now().toLocal();
  var newFormat = DateFormat("yy-MM-dd   hh:mm  aaa");
  var strToDateTime = DateTime.parse(time.toString());
  final convertLocal = strToDateTime.toLocal();
  String trueTime = newFormat.format(convertLocal);
  return trueTime;
}

bool admin = true;

class _orderHistoryCardState extends State<orderHistoryCard> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    if (user != null) {
      if (user.email == 'admin@email.com') {
        admin = true;
      } else {
        admin = false;
      }
    }

    DateTime orderDAte = DateFormat("yy-MM-dd   hh:mm  aaa")
        .parse(getDateFormated(widget.data, 'reservation_datetime'));
    DateTime localDate =
        DateFormat("yy-MM-dd   hh:mm  aaa").parse(getTodayDate());
    bool orderTiming = orderDAte.isBefore(localDate);
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
            } else {
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
                                  fontSize:
                                      MediaQuery.of(context).size.width > 400
                                          ? 22
                                          : 18,
                                  fontWeight: FontWeight.w500,
                                )),
                              ),
                              Text(
                                '#' + widget.orderId,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 380
                                          ? 16
                                          : 10,
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
                                        "X" +
                                            iteamCounter.toString() +
                                            " iteams",
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
                                  width: MediaQuery.of(context).size.width > 380
                                      ? 90
                                      : 30,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        !admin
                                            ? showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    FeedbackDialog(
                                                      id: widget.orderId,
                                                    ))
                                            : showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    adminFeedbackDialog(
                                                      id: widget.orderId,
                                                    ));
                                      },
                                      icon: Icon(
                                        admin ? Icons.add_alert : Icons.reviews,
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
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                label: Text(
                                  orderTiming ? "Completed" : "Pending",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 1, color: Colors.green),
                                    padding: EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13))),
                                icon: Icon(
                                  orderTiming
                                      ? Icons.check
                                      : Icons.pending_rounded,
                                  size: 28,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
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
            fontWeight: FontWeight.w100,
            fontSize: MediaQuery.of(context).size.width > 380 ? 19 : 15,
            color: Colors.white));
    var Value = GoogleFonts.sora(
        textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.width > 380 ? 14 : 12,
            color: Colors.white));

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
                    padding: EdgeInsets.all(2),
                    height: MediaQuery.of(context).size.width > 380
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width > 380
                        ? MediaQuery.of(context).size.width * 0.95
                        : MediaQuery.of(context).size.width * 0.95,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Order Detail",
                              style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  380
                                              ? 22
                                              : 16,
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
                          // margin: EdgeInsets.all(2),
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
                                children: [
                                  Text(
                                    "Address =>",
                                    style: Title,
                                  ),
                                ],
                              ),
                              Text(
                                data['address'],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Value,
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
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.44,
                            child: ListView.builder(
                              // padding: EdgeInsets.all(1),
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                //elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                side:
                                    BorderSide(width: 2, color: Colors.yellow),
                              ),
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              )),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
