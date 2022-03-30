import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snow_remover/UiScreen/sign_Up.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snow_remover/components/toast_message/ios_Style.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:snow_remover/utility.dart' as utility;

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

// string for displaying the error Message
String? errorMessage;

class _SignInState extends State<SignIn> {
  // firebase
  final _auth = FirebaseAuth.instance;

  Map? userData;

  var loading = false;

  void logInWithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      await FacebookAuth.getInstance().logOut();
      final facebookLogResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredential =
          FacebookAuthProvider.credential(facebookLogResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      var collection = await FirebaseFirestore.instance.collection('users');
      await collection.doc(uid).set({
        'email': userData['email'],
        'Firstname': userData['name'],
        'uid': uid
      }).then((value) => print("added"));
      // await FirebaseFirestore.instance.collection("users").add({
      // Navigator.pushNamed(context, '/bottom_nav');
      _navigateToHome();
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exist-with-different-credential':
          title = "this account with linked with different sign in provider";
          break;
        case 'invalid-credential':
          title = "unKnown error has occered";
          break;
        case 'user-disabled':
          title = "user account is disabled";
          break;
      }
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: IosStyleToast(label: title),
        );
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    print(screenHeight);
    return screenHeight < 550
        ? SingleChildScrollView(
            child: Scaffold(
              body: Form(
                key: _formKey,
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 1,
                  decoration: const BoxDecoration(color: Color(0xFF34A8DB)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: -30,
                            bottom: -90,
                            child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                    "assets/images/Rectangle 35.png")),
                          ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Sign In",
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
                        height: MediaQuery.of(context).size.height * 0.12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        // height: MediaQuery.of(context).size.height * 0.10,
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.mail),
                            labelStyle: const TextStyle(fontSize: 18),
                            labelText: "Email",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            counterStyle: const TextStyle(fontSize: 60),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            // reg expression for email validation
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        //height: MediaQuery.of(context).size.height * 0.10,
                        child: TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            //contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                          controller: passwordController,
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
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700))),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(250, 50),
                          onPrimary: Colors.white,
                          primary: Colors.red,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onPressed: () {
                          signIn(emailController.text, passwordController.text);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          label: Text(
                            "Sign Up With",
                            style: GoogleFonts.commissioner(
                              textStyle: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 50),
                            onPrimary: Colors.white,
                            primary: Colors.purple,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          icon: Icon(Icons.facebook),
                          onPressed: () async {
                            FirebaseAuth.instance
                                .authStateChanges()
                                .listen((User? user) {
                              if (user == null) {
                                logInWithFacebook();
                              } else {
                                showOverlay((context, t) {
                                  return Opacity(
                                    opacity: t,
                                    child:
                                        IosStyleToast(label: "user is sign in"),
                                  );
                                });
                                // Navigator.pushNamed(context, '/bottom_nav');
                                _navigateToHome();
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 3,
                        color: Colors.white,
                        endIndent: 30,
                        indent: 30,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignUp(key: UniqueKey())));
                        },
                        child: const Text(
                          "Create a new account",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 1,
                  decoration: const BoxDecoration(color: Color(0xFF34A8DB)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.10,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -90,
                            child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                    "assets/images/Rectangle 35.png")),
                          ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        // height: MediaQuery.of(context).size.height * 0.10,
                        child: TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.mail),
                            labelStyle: const TextStyle(fontSize: 18),
                            labelText: "Email",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            counterStyle: const TextStyle(fontSize: 60),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(),
                            ),
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            // reg expression for email validation
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        //height: MediaQuery.of(context).size.height * 0.10,
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            //contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                          controller: passwordController,
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
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700))),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(250, 50),
                          onPrimary: Colors.white,
                          primary: Colors.red,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onPressed: () {
                          signIn(emailController.text, passwordController.text);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          label: Text(
                            "Sign Up With",
                            style: GoogleFonts.commissioner(
                              textStyle: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 50),
                            onPrimary: Colors.white,
                            primary: Colors.purple,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          icon: Icon(Icons.facebook),
                          onPressed: () async {
                            FirebaseAuth.instance
                                .authStateChanges()
                                .listen((User? user) {
                              if (user == null) {
                                logInWithFacebook();
                              } else {
                                showOverlay((context, t) {
                                  return Opacity(
                                    opacity: t,
                                    child:
                                        IosStyleToast(label: "user is sign in"),
                                  );
                                });
                                // Navigator.pushNamed(context, '/bottom_nav');
                                _navigateToHome();
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 3,
                        color: Colors.white,
                        endIndent: 30,
                        indent: 30,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SignUp(key: UniqueKey())));
                        },
                        child: const Text(
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

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) {
          showOverlay((context, t) {
            return Opacity(
              opacity: t,
              child: const IosStyleToast(label: "Login successfully"),
            );
          });
          // Navigator.pushReplacementNamed(context, '/bottom_nav');
          _navigateToHome();
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

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    DocumentSnapshot? userInfo = await utility.fetchUser();
    if (userInfo != null &&
        userInfo.get("type").toString().toLowerCase() == "admin") {
      Navigator.pushReplacementNamed(context, '/admin_bottomnav');
      // signed in
    } else {
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    }
  }

/* facebookLogin() async {
    final result = await FacebookAuth.i.login(
        permissions: ["public_profile", "email"]
    );
    if (result.status == LoginStatus.success) {
      var userData = await FacebookAuth.i.getUserData(
          fields: "email,name"
      );


    }
  }*/

}
