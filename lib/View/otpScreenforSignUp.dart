// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_null_comparison, unnecessary_this, non_constant_identifier_names, prefer_function_declarations_over_variables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/Controller/auth.dart';
import '/Controller/sharedPreferance.dart';
import '/View/Doctor/Home_Screen_doctor.dart';
import '/View/Pateint/Home_Screen_Pateint.dart';
import '/View/welcome.dart';
import '/main.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPSIGNUP extends StatefulWidget {
  const OTPSIGNUP({
    Key? key,
    required this.phoneNo,
    required this.email,
    required this.name,
    required this.role,
    required this.specialty,
  }) : super(key: key);

  final dynamic phoneNo;
  final dynamic name;
  final dynamic email;
  final dynamic role;
  final dynamic specialty;
  @override
  State<OTPSIGNUP> createState() => _OTPSIGNUPState();
}

class _OTPSIGNUPState extends State<OTPSIGNUP> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? smsCode;
  String? verificationId;
  bool isloader = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _pinPutController = TextEditingController();
  Timer? _timer;
  int start = 59;
  bool isLoading = true;
  Auth _auth = Auth();

  @override
  void initState() {
    _verifyPhone(context);
    startTimer();
    super.initState();
  }

  void startTimer() {
    const Sec = Duration(seconds: 1);
    _timer = Timer.periodic(Sec, (Timer timer) {
      if (mounted) {
        setState(() {
          if (start == 0) {
            setState(() {
              isLoading = false;
            });
            _timer?.cancel();
            Navigator.pop(context);
          } else {
            start = start - 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            height: _height * 100,
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
                Flexible(
                  child: SizedBox(),
                  fit: FlexFit.tight,
                ),
                Container(
                  height: _height * 40,
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //SizedBox(height: 10,),
                      Text(
                        "Enter OTP",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: PinCodeTextField(
                          enableActiveFill: true,
                          enablePinAutofill: true,
                          controller: _pinPutController,
                          autoDismissKeyboard: true,

                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          appContext: context,
                          length: 6,
                          obscureText: false,
                          //obscuringCharacter: '*',

                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            activeFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.blue,
                          ),
                          animationDuration: const Duration(milliseconds: 300),

                          onCompleted: (v) async {
                            print(_pinPutController);
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {});
                          },
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Resend otp",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "0:${start}",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isloader
                          ? Container(
                              width: _width * 80,
                              child: LinearProgressIndicator())
                          : Container(
                              height: _height * 7,
                              width: _width * 90,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isloader = true;
                                    });
                                    _SignupWithMobile();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>  otp_screen()),
                                    // );
                                  },
                                  child: Text(
                                    "Confirm",
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
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  //  decoration: BoxDecoration(

                  //     color: Colors.black87.withOpacity(0.9),
                  //     image: DecorationImage(
                  //       fit: BoxFit.cover,
                  //       colorFilter: ColorFilter.mode(
                  //           Colors.white.withOpacity(0.4), BlendMode.dstATop),
                  //       image: AssetImage("assets/banner.jpg"),
                  //     ))
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

  _SignupWithMobile() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print("!");
    smsCode = await _pinPutController.text.trim();
    print("!!");
    var _credential = await PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: smsCode!);
    print("!!!");
    await auth
        .signInWithCredential(_credential)
        .then((UserCredential result) async {
      User user = result.user!;

      print("red bull ${user.uid}");
      print("!!!!");
      final tokenResult = auth.currentUser;
      final idToken = await tokenResult!.getIdToken();

      if (result != null) {
        print(result.user);
        int mobileNo = int.parse(widget.phoneNo);
        assert(mobileNo is int);

        setState(() {
          isLoading = true;
        });
        print("${widget.name} $mobileNo ${widget.role} ");
        Auth auth = Auth();
        auth
            .createUser(
                widget.name, mobileNo, "plplpl00", widget.email, widget.role , widget.specialty)
            .then((value) {
          if (value == 200 || value == 201) {
            preferences?.setBool(
                QuestionSharedpreferance.isFirstTimeUser, true);
            print(
                "sat first user ${preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser)}");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => welcome()),
                (route) => false);
            setState(() {
              isLoading = false;
            });
          } else {
            Navigator.pop(context);
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
    }).catchError((e) {
      Fluttertoast.showToast(msg: "OTP is wrong");

      print(e.toString());
    });
  }

  Future<void> _verifyPhone(BuildContext context) async {
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent SMSCodeSent = (String verId, [int? forceCodeResend]) {
      this.verificationId = verId;
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      print("Phone verification is success");
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Mobile verification Failed..");
      print("${exception.message}");
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNo}",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: SMSCodeSent,
        timeout: const Duration(seconds: 5),
        codeAutoRetrievalTimeout: autoRetrive);
  }
}
