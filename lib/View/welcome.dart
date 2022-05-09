import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_null_comparison, unnecessary_this, non_constant_identifier_names, prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';
import '/Controller/auth.dart';
import '/View/Doctor/Home_Screen_doctor.dart';
import '/View/Pateint/Home_Screen_Pateint.dart';

import '/View/log_in.dart';
import '/View/sign_up.dart';

class welcome extends StatefulWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: _height * 10,
                ),
                Image.asset(
                  "assets/logo1.png",
                  height: 110,
                  width: 160,
                ),
                Text(
                  "Welcome to Simpli Healthy",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "LoremLorem ipsum dolor sit amet, consectet adipisclor sit amet, consectetur adipiscing elit. Pharetra quis nascetur d",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: _height * 20,
                ),
                Container(
                  height: _height * 7,
                  width: _width * 80,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Sign_Up()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: _width * 5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: Colors.white))))),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? Container(
                        width: _width * 80, child: LinearProgressIndicator())
                    : Container(
                        height: _height * 7,
                        width: _width * 80,
                        child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await signup(context);
                              startTimer();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/google.png",
                                  height: 35,
                                  width: 35,
                                ),
                                Text(
                                  " Countinue with google",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: _width * 5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side:
                                            BorderSide(color: Colors.white))))),
                      ),
                const Flexible(
                  child: SizedBox(),
                  fit: FlexFit.tight,
                ),
                InkWell(
                  onTap: () {
                    GoogleSignIn().disconnect();
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    "Already have an account",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  },
                  child: Text(
                    "Log in",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.9),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.4), BlendMode.dstATop),
                image: AssetImage("assets/banner.png"),
              ))),
    );
  }

  startTimer() {
    // Timer(Duration(seconds: 10), () {
    //   // GoogleSignIn().disconnect();
    //   // FirebaseAuth.instance.signOut();
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  Future<void> signup(BuildContext context) async {
    // GoogleSignIn().disconnect();
    // FirebaseAuth.instance.signOut();

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;

      print("red bull ${user.email}");

      String acToken = googleSignInAuthentication.accessToken!;

      final tokenResult = auth.currentUser;
      final idToken = await tokenResult!.getIdToken();

      if (result != null) {
        print("hell ${result.user}");
        Auth auth = Auth();

        String username = user.displayName!.split(" ")[0].toLowerCase();

        auth.loginByGoogleSignIn(user.email, username).then((value) {
          if (value[0] == 200 || value[0] == 201) {
            print("user id & role  ${value[1]} ${value[2]}");
            setState(() {
              isLoading = false;
            });
            if (value[2] == 'doctor') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreenDoctor(
                          id: value[1],
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreenPateint(
                          id: value[1],
                        )),
              );
            }
            final snakbar = const SnackBar(
              content: Text("Logged in Successfully"),
              backgroundColor: (Colors.black),
              elevation: 10,
              dismissDirection: DismissDirection.endToStart,
            );
            ScaffoldMessenger.of(context).showSnackBar(snakbar);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
}
