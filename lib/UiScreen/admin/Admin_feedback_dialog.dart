import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class adminFeedbackDialog extends StatefulWidget {
  String id;

  @override
  State<adminFeedbackDialog> createState() => _adminFeedbackDialogState();

  adminFeedbackDialog({
    required this.id,
  });
}

class _adminFeedbackDialogState extends State<adminFeedbackDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChange1(int value) {
    setState(() {
      selectedValue1 = value;
    });
  }

  int selectedValue1 = 1;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('orders')
        .where(FieldPath.documentId, isEqualTo: widget.id)
        .snapshots(includeMetadataChanges: true);

    return AlertDialog(
        elevation: 3,
        title: Text(
          "Review",
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        //scrollable: true,

        content: StreamBuilder(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
              return Container(
                  height: 140.0, // Change as per your requirement
                  width: 240.0, // Change as per your requirement
                  child: ListView(
                    children: snapshot.data!.docs.map((
                        DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<
                          String,
                          dynamic>;
                      return ListTile(
                        title: data['feedback'] == "" ? Text(" no new review ") : Text(data['feedback']),
                      );
                    }).toList(),
                  )
              );
            return Text("no new review");
          },
        ),
        actions: [
          TextButton(
            child: const Text('Go back'),
            onPressed: () => Navigator.pop(context),
          ),
        ]);
  }
}
