import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SignIn.dart';

final NameEditingController = new TextEditingController();
final emailEditingController = new TextEditingController();
final passwordEditingController = new TextEditingController();
final confirmPasswordEditingController = new TextEditingController();

class signUp extends StatelessWidget {
  signUp({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: new BoxDecoration(color: Color(0xFF34A8DB)),
            child: new Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Positioned(
                      bottom: -90,
                      child: Container(
                          alignment: Alignment.center,
                          child: new Image.asset(
                              "assets/images/Rectangle 35.png")),
                    ),
                    Positioned(
                      child: Container(
                        alignment: Alignment.center,
                        child: new Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      labelStyle: TextStyle(fontSize: 18),
                      labelText: "Name",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    controller: NameEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Name");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+.[a-z]").hasMatch(value)) {
                        return ("Invaid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      NameEditingController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: Icon(Icons.mail),
                      labelStyle: TextStyle(fontSize: 18),
                      labelText: "Email",
                      counterStyle: TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    controller: emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Email");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Invaid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      emailEditingController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: Icon(Icons.vpn_key),
                      labelStyle: TextStyle(fontSize: 18),
                      labelText: "Password",
                      counterStyle: TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    controller: passwordEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(color: Colors.black),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Please Enter Your Password");
                      }
                      // reg expression for email validation
                      if (!regex.hasMatch(value)) {
                        return ("Must be larger then 6");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      passwordEditingController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: Icon(Icons.vpn_key),
                      labelStyle: TextStyle(fontSize: 18),
                      labelText: "Confirm Password",
                      counterStyle: TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    controller: confirmPasswordEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(color: Colors.black),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Please Enter Your Password");
                      }
                      // reg expression for email validation
                      if (!regex.hasMatch(value)) {
                        return ("Must be larger then 6");
                      }
                      if (confirmPasswordEditingController.text !=
                          passwordEditingController.text) {
                        return "Password don't match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      passwordEditingController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  child: Text('SIGN UP',
                      style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    fixedSize: const Size(250, 45),
                    onPrimary: Colors.white,
                    primary: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                    ;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ElevatedButton(
                  child: Text('SIGN UP WITH',
                      style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    fixedSize: const Size(300, 45),
                    onPrimary: Colors.white,
                    primary: Colors.purple,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  onPressed: () {
                    print('Pressed');
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  height: 2,
                  thickness: 3,
                  color: Colors.white,
                  endIndent: 30,
                  indent: 30,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => signIn(key: UniqueKey())));
                  },
                  child: Text(
                    "Already have a account Sign In ",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
