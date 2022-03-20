import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF34A8DB),
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF34A8DB),
          size: 30.0,
        ),
        title: const Text("User Profile"),
        actions: const [
          Icon(
            Icons.logout_rounded,
            color: Colors.white,
            size: 30.0,
          )
        ],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white, //                   <--- border color
                    width: 2.0,),
                  image:  const DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/snowremovalapp-ac3d9.appspot.com/o/5-52097_avatar-png-pic-vector-avatar-icon-png-transparent-removebg-preview.png?alt=media&token=5ce9281a-22ca-4538-8176-86bd97e50975")
                  ),),

              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                          children:   [
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                )),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  labelStyle: const TextStyle(fontSize: 18),
                                  labelText: "Name",
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  counterStyle: const TextStyle(fontSize: 60),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
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
                                onSaved: (value) {},
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  "Example@email.com",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                )),
                          ],
                        )),
                     Expanded(
                        child: Row(
                          children:  [
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                )),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  labelStyle: const TextStyle(fontSize: 18),
                                  labelText: "Password",
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  counterStyle: const TextStyle(fontSize: 60),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(),
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please Enter Your Password");
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),),
                          ],
                        )),
                    Expanded(
                        child: Row(
                          children:  [
                            const Expanded(
                                flex: 1,
                                child: Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                )),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  labelStyle: const TextStyle(fontSize: 18),
                                  labelText: "Confirm Passwords",
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  counterStyle: const TextStyle(fontSize: 60),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(),
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please Enter Your Confirm Password");
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
                              ),),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          height: 60.0,
                          minWidth: double.infinity,
                          color: Colors.deepOrange,
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Text(
                            "Update",
                            style:  TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
