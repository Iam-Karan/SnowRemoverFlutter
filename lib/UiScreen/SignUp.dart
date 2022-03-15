import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'SignIn.dart';
class signUp extends StatelessWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,

          decoration: new BoxDecoration(color: Color(0xFF34A8DB)),
          child: new Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    bottom: -90,
                    child: Container(
                        alignment: Alignment.center,
                        child: new Image.asset("assets/images/Rectangle 35.png")),
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
                height: 80,
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 20,
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
                  print('Pressed');
                },
              ),
              SizedBox(
                height: 20,
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
                height: 15,
              ),
              Divider(
                height: 2,
                thickness: 3,
                color: Colors.white,
                endIndent: 30,
                indent: 30,
              ),
              SizedBox(height: 4,),
              TextButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => signIn(key: UniqueKey())));
              },
                child:Text("already have a account Sign In ",style: TextStyle(fontSize: 18,color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
