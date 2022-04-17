import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FeedbackDialog extends StatefulWidget {
  String id;

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();

  FeedbackDialog({
    required this.id,
  });
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

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
    return  AlertDialog(
        elevation: 3,
        // contentPadding: EdgeInsets.all(10),
        title: Text(
          "Review",
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        // insetPadding: EdgeInsets.all(40),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter your review here',
                    filled: true,
                  ),
                  maxLines: 5,
                  maxLength: 4096,
                  textInputAction: TextInputAction.done,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Send'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String message;

                try {
                  final collection =
                      FirebaseFirestore.instance.collection('orders');

                  await collection.doc(widget.id).update({
                    'feedback': _controller.text,
                  });

                  message = 'Review sent successfully';
                } catch (e) {
                  message = 'Error when sending Review';
                }

                // Show a snackbar with the result
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
                Navigator.pop(context);
              }
            },
          )
        ],
      
    );
  }
}
