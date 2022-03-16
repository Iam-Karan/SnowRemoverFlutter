import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/first_time_sign_in.dart';
import 'package:snow_remover/components/toast_message/ios_Style.dart';
import 'sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final nameEditingController = TextEditingController();
final emailEditingController = TextEditingController();
final passwordEditingController = TextEditingController();
final confirmPasswordEditingController = TextEditingController();

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(color: Color(0xFF34A8DB)),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: -90,
                      child: Container(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/Rectangle 35.png")),
                    ),
                    Positioned(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      labelStyle: const TextStyle(fontSize: 18),
                      labelText: "Name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    controller: nameEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
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
                      nameEditingController.text = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: const Icon(Icons.mail),
                      labelStyle: const TextStyle(fontSize: 18),
                      labelText: "Email",
                      counterStyle: const TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    controller: emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      //contentPadding: const EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: const Icon(Icons.vpn_key),
                      labelStyle: const TextStyle(fontSize: 18),
                      labelText: "Password",

                      counterStyle: const TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    controller: passwordEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: TextFormField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      //contentPadding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 10.0),
                      filled: true,
                      prefixIcon: const Icon(Icons.vpn_key),
                      labelStyle: const TextStyle(fontSize: 18),
                      labelText: "Confirm Password",
                      counterStyle: const TextStyle(fontSize: 60),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    controller: confirmPasswordEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
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
                          textStyle: const TextStyle(
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
                    signUp(
                        emailEditingController.text,
                        passwordEditingController.text,
                        nameEditingController.text);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ElevatedButton(
                  child: Text('SIGN UP WITH',
                      style: GoogleFonts.commissioner(
                          textStyle: const TextStyle(
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
                  onPressed: () {},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                const Divider(
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
                            builder: (context) => SignIn(key: UniqueKey())));
                  },
                  child: const Text(
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

  void signUp(String email, String password, String name) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          toast(e.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        toast(errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = nameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    showOverlay((context, t) {
      return Opacity(
        opacity: t,
        child: const IosStyleToast(label: "Account created"),
      );
    });
    Navigator.of(context).pushNamed(
      '/SignIn',
    );
  }
}
