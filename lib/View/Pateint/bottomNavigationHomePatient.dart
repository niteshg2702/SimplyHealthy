// ignore_for_file: file_names
import 'dart:io';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '/Colors/Colors.dart';
import '/Controller/auth.dart';
import '/View/Pateint/item_Report.dart';
import '/View/Doctor/item_blogList.dart';
import '/View/Pateint/Camera.dart';
import '/View/Pateint/Recommandation.dart';

import '/View/Pateint/item_P_doctorList.dart';
import '/View/Pateint/item_P_blogList.dart';
import '/View/Pateint/item_P_pdfList.dart';

class BottomNavigationPatient extends StatefulWidget {
  const BottomNavigationPatient(
      {Key? key,
      required this.id,
      required this.avatar,
      required this.name,
      required this.email,
      required this.mobile})
      : super(key: key);

  final String avatar;
  final dynamic id;
  final dynamic name;
  final dynamic email;
  final dynamic mobile;
  @override
  State<BottomNavigationPatient> createState() =>
      _BottomNavigationPatientState();
}

class _BottomNavigationPatientState extends State<BottomNavigationPatient> {
  int _currentIndex = 0;
  List avtar = ["assets/f1.png", "assets/f2.png", "assets/f3.png"];
  String? selectedAvtar;
  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";

  dynamic username, useremail, usermobile;
  void initState() {
    setState(() {
      username = widget.name;
      useremail = widget.email;
      usermobile = widget.mobile;
      selectedAvtar = widget.avatar;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [
      Item_Report(id: widget.id,),
      item_P_PDFList(
        id: widget.id,
        name: widget.name,
      ),
      item_P_doctorList(),
      Item_P_BlogList(id: widget.id),
    ];
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async {
            // GoogleSignIn().disconnect();
            // FirebaseAuth.instance.signOut();
            return true;
          },
          child: Container(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: _height * 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          EditUserProfile(username, useremail, usermobile,
                              selectedAvtar, widget.id);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.zero),
                          child: Image.asset(
                            selectedAvtar!,
                            scale: 15,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: _width * 10,
                      // ),
                      Image.asset(
                        "assets/logo1.png",
                        scale: 3.5,
                      ),
                      // SizedBox(
                      //   width: _width * 10,
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Recommandation(
                                        role: "patient",
                                        id: widget.id,
                                        avatar: widget.avatar,
                                        name: widget.name,
                                        email: widget.email,
                                        mobile: widget.mobile,
                                      )));
                        },
                        child: Image.asset("assets/question.png",
                            scale: 3, fit: BoxFit.cover),
                      )
                    ],
                  ),
                ),
                _pageOptions[_currentIndex],
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          elevation: 10,
          iconSize: 25.0,
          selectedColor: Color(0xff040307),
          strokeColor: Color(0x30040307),
          unSelectedColor: Color(0xffacacac),
          backgroundColor: Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.filePdf),
            ),
            // CustomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.camera),
            // ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.plusSquare),
            ),
            CustomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookOpen),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: InkWell(
          onTap: () {
            getImage();
            // captureImage(ImageSource.camera).then((value) {
            //   if (value.toString().length != 0) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => Camera(
            //                 ImagePath: value,
            //               )),
            //     );
            //   }
            // });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => CameraApp()),
            // );
          },
          child: Card(
            elevation: 5,
            color: Color(0xffacacac),
            shadowColor: Colors.black87,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                FontAwesomeIcons.camera,
                color: Colors.white,
                size: 35,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ));
  }

  Future getImage() async {
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            //content: Text('Select where you want to capture the image from'),
            title: Text(
              'Select Image',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            actions: <Widget>[
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // seleccion = SelectSource.camara;
                  captureImage(ImageSource.gallery).then((value) {
                    if (value.toString().length != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Camera(
                                  ImagePath: value,
                                  id: widget.id,
                                )),
                      );
                    }
                  });
                  // Navigator.of(context, rootNavigator: true).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text('Camera '),
                      Icon(Icons.camera_alt_rounded),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // seleccion = SelectSource.camara;
                  captureImage(ImageSource.camera).then((value) {
                    if (value.toString().length != 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Camera(
                                  ImagePath: value,
                                  id: widget.id,
                                )),
                      );
                    }
                  });
                  //Navigator.of(context, rootNavigator: true).pop();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text('Gallery '),
                      Icon(FontAwesomeIcons.fileImage),
                    ]),
              ),
            ],
          );
        }));
    // showDialog<AlertDialog>(context: context, a);
  }

  Future captureImage(ImageSource option) async {
    XFile? image;
    File imagePath;

    option == ImageSource.gallery
        ? image = await ImagePicker().pickImage(source: ImageSource.camera)
        : image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      print("image path by taken mobile camera ${image!.path}");
      var photo = image;
    });

    imagePath = File(image!.path);

    return imagePath;
  }

  Future EditUserProfile(name, email, mobile, image, id) async {
    final formGlobalKey = GlobalKey<FormState>();
    // TextEditingController _name = TextEditingController();
    // TextEditingController _email = TextEditingController();
    // TextEditingController _mobile = TextEditingController();
    String selectedAvtarLocal = image;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return Container(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              scrollable: true,
              title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedAvtarLocal = "assets/f1.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtarLocal == "assets/f1.png"
                              ? Colors.blue
                              : Colors.white,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage("assets/f1.png"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedAvtarLocal = "assets/f2.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtarLocal == "assets/f2.png"
                              ? Colors.blue
                              : Colors.white,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.deepOrange,
                            backgroundImage: AssetImage("assets/f2.png"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedAvtarLocal = "assets/f3.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtarLocal == "assets/f3.png"
                              ? Colors.blue
                              : Colors.white,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.lime,
                            backgroundImage: AssetImage("assets/f3.png"),
                          ),
                        ),
                      ),
                    ]);
              }),
              //content: Text('Select where you want to capture the image from'),
              content: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Profile',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: name,
                        //controller: _name,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final nameRegExp = RegExp(r"^[a-zA-Z0-9]");

                          if (!nameRegExp.hasMatch(value.toString())) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Name",
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: hinttextColor,
                                  fontWeight: FontWeight.w500)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: col3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: textFieldColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: email,
                        //controller: _email,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (!emailRegExp.hasMatch(email.toString())) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Email",
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: hinttextColor,
                                  fontWeight: FontWeight.w500)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: col3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: textFieldColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: mobile.toString(),
                        //controller: _mobile,
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          if (value!.length != 10) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Mobile",
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: hinttextColor,
                                  fontWeight: FontWeight.w500)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: col3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textFieldColor),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        final isValid = formGlobalKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        } else {
                          formGlobalKey.currentState!.save();

                          final m = await int.parse(mobile.toString());
                          assert(m is int);
                          print("update ${m.runtimeType}");
                          Auth auth = Auth();
                          auth
                              .updateUserProfile(
                                  name, m, email, id, selectedAvtarLocal)
                              .then((value) {
                            if (value == 201 || value == 200) {
                              setState(() {
                                selectedAvtar = selectedAvtarLocal;
                                username = name;
                                useremail = email;
                                usermobile = mobile;
                              });
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 40),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ).build(context),
          );
        }));
  }
}
