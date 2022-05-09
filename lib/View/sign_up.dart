// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Controller/auth.dart';
import '/Controller/sharedPreferance.dart';
import '/View/SignUpTwo.dart';
import '/View/welcome.dart';
import '/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({Key? key}) : super(key: key);

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  String? mobileno;
  final formGlobalKey = GlobalKey<FormState>();
  String? name;
  String? password;
  String? email;
  String? confirmpassword;
  int _radioSelected = 1;
  String role = "patient";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Container(
      height: double.infinity,
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.9),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.4), BlendMode.dstATop),
            image: AssetImage("assets/banner.png"),
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
              height: _height * 5,
            ),
            Image.asset(
              "assets/logo1.png",
              height: 110,
              width: 160,
            ),
            const Flexible(
              child: SizedBox(),
              fit: FlexFit.tight,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 35, 20),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Register",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //initialValue: name,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.black),
                      validator: (value) {
                        final nameRegExp = RegExp(
                            r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

                        if (!nameRegExp.hasMatch(value!)) {
                          return "Please Enter Name with surname";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() {
                        this.name = value;
                      }),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Full Name",
                        isDense: true,
                        contentPadding: EdgeInsets.all(13),
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        errorStyle: TextStyle(color: Colors.white, height: 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          //borderSide:  BorderSide(color: textFieldColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextFormField(
                    //   //initialValue: name,
                    //   keyboardType: TextInputType.phone,
                    //   textAlign: TextAlign.start,
                    //   style: GoogleFonts.montserrat(
                    //       fontSize: 18, color: Colors.black),
                    //   validator: (value) {
                    //     if (value!.length != 10) {
                    //       return "Please Enter Valid Phone No";
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    //   onChanged: (value) => setState(() {
                    //     this.mobileno = value;
                    //   }),
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     hintText: "Enter Mobile Number",
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.all(13),
                    //     hintStyle: GoogleFonts.montserrat(
                    //       fontSize: 18,
                    //       color: Colors.grey,
                    //     ),
                    //     errorStyle: TextStyle(color: Colors.white, height: 1),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     enabledBorder: UnderlineInputBorder(
                    //       //borderSide:  BorderSide(color: textFieldColor),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //   ),
                    // ),

                    TextFormField(
                      //initialValue: name,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.black),
                      validator: (value) {
                        final emailRegExp = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if (!emailRegExp.hasMatch(email!)) {
                          return "Please Enter Valid email";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() {
                        this.email = value;
                      }),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Email",
                        isDense: true,
                        contentPadding: EdgeInsets.all(13),
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        errorStyle: TextStyle(color: Colors.white, height: 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          //borderSide:  BorderSide(color: textFieldColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // TextFormField(
                    //   //initialValue: name,
                    //   obscureText: false,
                    //   obscuringCharacter: "*",
                    //   keyboardType: TextInputType.visiblePassword,
                    //   textAlign: TextAlign.start,
                    //   style: GoogleFonts.montserrat(
                    //       fontSize: 18, color: Colors.black),
                    //   validator: (value) {
                    //     //    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                    //     // RegExp regExp = new RegExp(pattern);
                    //     // if (!regExp.hasMatch(value!)) {
                    //     //   return "1-uppercase,1-lowercase,min. 1 number,min 1 special character";
                    //     // } else {
                    //     //   return null;
                    //     // }

                    //     if (value!.length < 8) {
                    //       return "Please Enter Valid Password";
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    //   onChanged: (value) => setState(() {
                    //     this.password = value;
                    //   }),
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     prefixIconConstraints: BoxConstraints(maxWidth: 50),
                    //     prefixIcon: const Center(
                    //         //padding: const EdgeInsets.fromLTRB(10,12, 10,12),
                    //         child: Icon(
                    //       Icons.lock_open,
                    //       size: 20,
                    //     )),
                    //     hintText: "Enter password ",
                    //     isDense: true,
                    //     errorStyle:
                    //         TextStyle(color: Colors.white, height: 1),
                    //     contentPadding: EdgeInsets.all(13),
                    //     hintStyle: GoogleFonts.montserrat(
                    //       fontSize: 18,
                    //       color: Colors.grey,
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     enabledBorder: UnderlineInputBorder(
                    //       //borderSide:  BorderSide(color: textFieldColor),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // TextFormField(
                    //   //initialValue: name,
                    //   obscureText: false,
                    //   obscuringCharacter: "*",

                    //   keyboardType: TextInputType.visiblePassword,
                    //   textAlign: TextAlign.start,
                    //   style: GoogleFonts.montserrat(
                    //       fontSize: 18, color: Colors.black),
                    //   validator: (value) {
                    //     if (value != password) {
                    //       return "password do not match    ";
                    //     } else {
                    //       return null;
                    //     }
                    //   },
                    //   onChanged: (value) => setState(() {
                    //     this.confirmpassword = value;
                    //   }),

                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     prefixIconConstraints: BoxConstraints(maxWidth: 50),
                    //     prefixIcon: const Center(
                    //         //padding: const EdgeInsets.fromLTRB(10,12, 10,12),
                    //         child: Icon(
                    //       Icons.lock,
                    //       size: 20,
                    //     )),
                    //     errorStyle:
                    //         TextStyle(color: Colors.white, height: 1),
                    //     hintText: "Enter confrim password",
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.all(13),
                    //     hintStyle: GoogleFonts.montserrat(
                    //       fontSize: 18,
                    //       color: Colors.grey,
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     enabledBorder: UnderlineInputBorder(
                    //       //borderSide:  BorderSide(color: textFieldColor),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _radioSelected,
                          activeColor: Colors.white,
                          onChanged: (int? value) {
                            setState(() {
                              _radioSelected = value!;
                              role = "patient";
                              print('$role');
                            });
                          },
                        ),
                        Text('Pateint',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15)),
                        Radio(
                          value: 2,
                          groupValue: _radioSelected,
                          activeColor: Colors.white,
                          onChanged: (int? value) {
                            setState(() {
                              _radioSelected = value!;
                              role = "doctor";
                              print('$role');
                            });
                          },
                        ),
                        Text('Doctor',
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    isLoading
                        ? Container(
                            width: _width * 80,
                            child: LinearProgressIndicator())
                        : Container(
                            height: _height * 7,
                            width: _width * 90,
                            child: ElevatedButton(
                                onPressed: () {
                                  final isValid =
                                      formGlobalKey.currentState!.validate();
                                  if (!isValid) {
                                    return;
                                  } else {
                                    formGlobalKey.currentState!.save();
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    // print(
                                    //     "$name $mobileno $password $confirmpassword $role ");
                                    // Auth auth = Auth();
                                    // int mobileNo = int.parse(mobileno!);
                                    // assert(mobileNo is int);
                                    // auth
                                    //     .createUser(name, mobileNo,
                                    //         confirmpassword, email, role)
                                    //     .then((value) {
                                    //   if (value == 200 || value == 201) {
                                    //     preferences?.setBool(
                                    //         QuestionSharedpreferance
                                    //             .isFirstTimeUser,
                                    //         true);
                                    //     print(
                                    //         "sat first user ${preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser)}");
                                    //     Navigator.pushAndRemoveUntil(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 welcome()),
                                    //         (route) => false);
                                    //     setState(() {
                                    //       isLoading = false;
                                    //     });
                                    //   } else {
                                    //     Navigator.pop(context);
                                    //     setState(() {
                                    //       isLoading = false;
                                    //     });
                                    //   }
                                    // });

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpTwo(name: name, email: email,role: role,)),
                                    );
                                  }
                                },
                                child: Text(
                                  "Next",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: Colors.white))))),
                          ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }
}
