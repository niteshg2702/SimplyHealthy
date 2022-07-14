// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Controller/auth.dart';
import '/Controller/sharedPreferance.dart';
import '/View/otpScreenforSignUp.dart';
import '/View/welcome.dart';
import '/main.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo(
      {Key? key,
      required this.name,
      required this.email,
      required this.role,
      required this.specialty})
      : super(key: key);

  final dynamic name;
  final dynamic email;
  final dynamic role;
  final dynamic specialty;
  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  String? mobileno;
  final formGlobalKey = GlobalKey<FormState>();
  String? confirmpassword;
  int _radioSelected = 1;
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
              //height: _height * 40,
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
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //initialValue: name,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: Colors.black),
                      validator: (value) {
                        if (value!.length != 10) {
                          return "Please Enter Valid Phone No";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() {
                        this.mobileno = value;
                      }),
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.grey[400],
                          size: 7,
                        ),
                        Text(
                          " An OTP will be sent to this number",
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                                    // print("${widget.name} $mobileno ${widget.role} ");
                                    // Auth auth = Auth();
                                    // int mobileNo = int.parse(mobileno!);
                                    // assert(mobileNo is int);
                                    // auth
                                    //     .createUser(widget.name, mobileNo,
                                    //         "plplpl00", widget.email, widget.role)
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
                                          builder: (context) => OTPSIGNUP(
                                              phoneNo: mobileno!,
                                              email: widget.email,
                                              name: widget.name,
                                              role: widget.role,
                                              specialty: widget.specialty,)),
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
