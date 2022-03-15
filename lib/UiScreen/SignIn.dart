import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/SignUp.dart';

final TextEditingController emailController = new TextEditingController();
final TextEditingController passwordController = new TextEditingController();
final _formKey = GlobalKey<FormState>();

class signIn extends StatelessWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            decoration: new BoxDecoration(color: Color(0xFF34A8DB)),
            child: new Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
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
                          "Sign In",
                          style: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  // height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
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
                    controller: emailController,
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
                      emailController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  //height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      //contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                    controller: passwordController,
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
                      passwordController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  child: Text('SIGN IN',
                      style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 50),
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
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('SIGN IN WITH',
                      style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
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
                  height: 15,
                ),
                Divider(
                  height: 2,
                  thickness: 3,
                  color: Colors.white,
                  endIndent: 30,
                  indent: 30,
                ),
                SizedBox(
                  height: 4,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => signUp(key: UniqueKey())));
                  },
                  child: Text(
                    "Create a new account",
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
