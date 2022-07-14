// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Colors/Colors.dart';
import '/Controller/auth.dart';
import '/Controller/sharedPreferance.dart';
import '/View/SignUpTwo.dart';
import '/View/welcome.dart';
import '/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  List<dynamic> _category = ['Cardiyplogy']; // Option 2
  String _selectedCategory = 'Cardiyology';

  void initState() {
    getAllCategory();
    super.initState();
  }

  Future getAllCategory() async {
    http.Response response = await http.get(Uri.parse(
        "https://pdf00.herokuapp.com/api/v1/views/user_blog_create"));

    print("${response.statusCode} ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var d = jsonDecode(response.body);
      setState(() {
        _category = d['catagories'];
        _selectedCategory = d['catagories'][0];
      });
    }
    print("category ${_category}");
  }

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
                    _radioSelected == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: DropdownButtonFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: col6,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: col3,
                                    fontWeight: FontWeight.w500),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: col3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: textFieldColor),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              dropdownColor: col6,
                              focusColor: col5,
                              hint: const Text(
                                  'Select Category'), // Not necessary for Option 1
                              value: _selectedCategory,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue.toString();
                                });
                              },
                              items: _category.map((gender) {
                                return DropdownMenuItem(
                                  child: Text(
                                    gender,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                    ),
                                  ),
                                  value: gender,
                                );
                              }).toList(),
                            ),
                          )
                        : Text(""),
                   
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
                                    

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpTwo(
                                                name: name,
                                                email: email,
                                                role: role,
                                                specialty:_selectedCategory
                                              )),
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
