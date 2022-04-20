import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({Key? key}) : super(key: key);

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

bool dataRead = true;
bool _hasbeenpressed = false;

class _AdminFeedbackState extends State<AdminFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Contact Messages",
            style: GoogleFonts.pacifico(
                textStyle: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 25,
            )),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: dataRead
                ? FirebaseFirestore.instance
                    .collection('contactMessages')
                    .where('read', isEqualTo: false)
                    .snapshots(includeMetadataChanges: true)
                : FirebaseFirestore.instance
                    .collection('contactMessages')
                    .where('read', isEqualTo: true)
                    .snapshots(includeMetadataChanges: true),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dataRead = true;
                          _hasbeenpressed = false;
                        });
                      },
                      child: Text("Read"),
                      style: ElevatedButton.styleFrom(
                        primary: _hasbeenpressed == false
                            ? Colors.redAccent
                            : Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dataRead = false;
                          _hasbeenpressed = true;
                        });
                      },
                      child: Text("Unread"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        primary:
                            _hasbeenpressed ? Colors.redAccent : Colors.blue,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Name -->",
                                        style: GoogleFonts.commissioner(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                      data['name'],
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Email -->",
                                        style: GoogleFonts.commissioner(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500))),
                                    Text(data['email'],
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic)))
                                  ],
                                ),
                                ListTile(
                                    contentPadding: EdgeInsets.all(1),
                                    leading: Text(
                                      "feedback -->",
                                      style: GoogleFonts.commissioner(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    title: Text(data['message'],
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic)))),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        dataRead
                                            ? updateRead(document.id)
                                            : updateReadToTrue(document.id);
                                      });
                                    },
                                    icon: Icon(dataRead
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    label: Text(dataRead
                                        ? "marked as unread"
                                        : "marked as Read"))
                              ],
                            ),
                          ));
                    }).toList(),
                  ),
                ),
              ]);
            }));
  }

  updateRead(String id) {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('contactMessages').doc(id).update({
      'read': true,
    });
  }

  updateReadToTrue(String id) {
    final databaseReference = FirebaseFirestore.instance;
    databaseReference.collection('contactMessages').doc(id).update({
      'read': false,
    });
  }
}
