import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:snow_remover/store/counter.dart';
import '../components/toast_message/ios_Style.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String uid = "";
  String name = "user";
  String email = "";

  late TextEditingController nameEditingController = TextEditingController();
  late TextEditingController oldPasswordEditingController =
      TextEditingController();
  late TextEditingController newPasswordEditingController =
      TextEditingController();
  late TextEditingController confirmPasswordEditingController =
      TextEditingController();

  final firebaseUser = FirebaseAuth.instance.currentUser!;

  Future<DocumentSnapshot> getUserData() async {
    uid = firebaseUser.uid;
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    name = ds.get('firstName');
    email = ds.get('email');
    print(name + '' + email);
    return ds;
  }

  void SignOut() {
    FirebaseAuth.instance.signOut();
    showOverlay((context, t) {
      return Opacity(
        opacity: t,
        child: const IosStyleToast(label: "Logout successfully"),
      );
    });
    Navigator.pushReplacementNamed(context, '/bottom_nav');
    context.read<Counter>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF34A8DB),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/bottom_nav');
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          title: const Text("User Profile"),
          actions: [
            GestureDetector(
              onTap: () {
                SignOut();
              },
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 30.0,
              ),
            )
          ],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors
                              .white, //                   <--- border color
                          width: 2.0,
                        ),
                        image: const DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/snowremovalapp-ac3d9.appspot.com/o/5-52097_avatar-png-pic-vector-avatar-icon-png-transparent-removebg-preview.png?alt=media&token=5ce9281a-22ca-4538-8176-86bd97e50975")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                        future: getUserData(),
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: nameEditingController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 18),
                                        labelText: name,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        counterStyle:
                                            const TextStyle(fontSize: 20),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Please Enter Your Name");
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        nameEditingController.text = value!;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "email",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        email,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.00),
                                      )),
                                ],
                              )),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Password",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: oldPasswordEditingController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        labelText: "Old Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        counterStyle:
                                            const TextStyle(fontSize: 20),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(),
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: newPasswordEditingController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        labelText: "New Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        counterStyle:
                                            const TextStyle(fontSize: 20),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(),
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Expanded(
                                      flex: 1,
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller:
                                          confirmPasswordEditingController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 20),
                                        labelText: "Confirm Passwords",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        counterStyle:
                                            const TextStyle(fontSize: 20),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(),
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            color: Colors.deepOrange,
                            onPressed: () {
                              updateProfile(
                                  nameEditingController.text,
                                  oldPasswordEditingController.text,
                                  newPasswordEditingController.text,
                                  confirmPasswordEditingController.text);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void updateProfile(String updatedName, String oldPassword, String newPassword,
      String confirmPassword) {
    var collection = FirebaseFirestore.instance.collection('users');
    if (updatedName != name) {
      collection.doc(uid).update({'firstName': updatedName});
      showOverlay((context, t) {
        return Opacity(
          opacity: t,
          child: const IosStyleToast(label: "Name updated successfully"),
        );
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }
    if (oldPassword.isNotEmpty && newPassword == confirmPassword) {
      RegExp regex = RegExp(r'^.{6,}$');
      if (!regex.hasMatch(newPassword)) {
        showOverlay((context, t) {
          return Opacity(
            opacity: t,
            child: const IosStyleToast(
                label: "Password must be longer then 6 digit"),
          );
        });
      } else {
        final cred =
            EmailAuthProvider.credential(email: email, password: oldPassword);
        firebaseUser.reauthenticateWithCredential(cred).then((value) {
          firebaseUser.updatePassword(newPassword).then((_) {
            showOverlay((context, t) {
              return Opacity(
                opacity: t,
                child: const IosStyleToast(
                    label: "Password updated successfully!"),
              );
            });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          }).catchError((error) {
            //Error, show something
          });
        }).catchError((err) {
          showOverlay((context, t) {
            return Opacity(
              opacity: t,
              child: const IosStyleToast(label: "Invalid password"),
            );
          });
        });
      }
    }
  }
}
