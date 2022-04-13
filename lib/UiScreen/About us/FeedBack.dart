import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../components/toast_message/ios_Style.dart';


class feedback extends StatefulWidget {
  const feedback({Key? key}) : super(key: key);

  @override
  State<feedback> createState() => _feedbackState();
}

final nameController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();

class _feedbackState extends State<feedback> {
  final _formKey = GlobalKey<FormState>();
  final maxLines = 5;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 19.0, horizontal: 10.0),
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 18),
                  labelText: "Name",
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                        color: Colors.blue, width: 3, style: BorderStyle.solid),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                        color: Colors.red, width: 3, style: BorderStyle.solid),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("field must not empty");
                  }
                  return null;
                },
                onSaved: (value) {
                  nameController.text = value!;
                },
                style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 19.0, horizontal: 10.0),
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 18),
                  labelText: "Email",
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                        color: Colors.blue, width: 3, style: BorderStyle.solid),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                        color: Colors.red, width: 3, style: BorderStyle.solid),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("field must not empty");
                  }
                },
                onSaved: (value) {
                  emailController.text = value!;
                },
                style: GoogleFonts.roboto(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
            SizedBox(
              height: 10,
            ),
            Container(
              height: maxLines * 24.0,
              child: TextFormField(
                  textAlign: TextAlign.start,
                  maxLines: maxLines,
                  controller: messageController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 19.0, horizontal: 10.0),
                    filled: true,
                    labelStyle: const TextStyle(fontSize: 18),
                    labelText: "Message",
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 3,
                          style: BorderStyle.solid),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 3,
                          style: BorderStyle.solid),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("field must not empty");
                    }
                  },
                  onSaved: (value) {
                    messageController.text = value!;
                  },
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
            ),
            SizedBox(height: 10,),
            ElevatedButton.icon(onPressed: (){
              giveFeedback(nameController.text,emailController.text,messageController.text);
              clear();
            }, icon: Icon(Icons.feedback), label: Text("send"))
          ],
        ),
      ),
    );
  }
giveFeedback( String name,
    String email,
    String message) async {
  if (_formKey.currentState!.validate()) {

    await FirebaseFirestore.instance
        .collection('feedback')
        .doc()
        .set({
      "name": name,
      "email": email,
      "message": message,
      "read": false,
    });
    showOverlay((context, t) {
      return Opacity(
        opacity: t,
        child: IosStyleToast(label: "Feedback send"),
      );
    });
  }
  }
  void clear() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }
}



