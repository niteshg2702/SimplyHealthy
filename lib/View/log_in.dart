import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_null_comparison, unnecessary_this, non_constant_identifier_names, prefer_function_declarations_over_variables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '/View/otp_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? mobileno;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: _height * 100,
            //padding: EdgeInsets.only(top: _height * 65),
            child: Column(
              children: [
                SizedBox(
                  height: _height * 10,
                ),
                SvgPicture.asset(
                  "assets/logo.svg",
                  height: 110,
                  width: 160,
                ),
                const Flexible(
                  child: SizedBox(),
                  fit: FlexFit.tight,
                ),
                Container(
                  height: _height * 40,
                  padding: const EdgeInsets.fromLTRB(20, 10, 25, 0),
                  child: Form(
                    key: formGlobalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Log In",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter Mobile Number",
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
                            initialCountryCode: 'IN',
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                                fontSize: 18, color: Colors.black),
                            onChanged: (value) => setState(() {
                              print(value.completeNumber);
                              this.mobileno = value.completeNumber;
                            }),
                            // validator: (phone) {
                            //   if (phone?.number.length != 10) {
                            //     return "Please Enter Valid Phone No";
                            //   } else {
                            //     return null;
                            //   }
                            // },
                          ),
                        ),
                        Container(
                          height: _height * 7,
                          width: _width * 90,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => otp_screen(
                                            phoneNo: mobileno!,
                                          )),
                                );
                              },
                              child: Text(
                                "Log In",
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
            decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.9),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.4), BlendMode.dstATop),
                  image: AssetImage("assets/banner.png"),
                ))),
      ),
    );
  }
}
