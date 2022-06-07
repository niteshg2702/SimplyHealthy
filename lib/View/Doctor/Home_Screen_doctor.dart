// ignore_for_file: file_names
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/Colors/Colors.dart';
import '/Controller/sharedPreferance.dart';
import '/View/Doctor/bottomNavigationHomeDoctor.dart';
import '/View/Pateint/Home_Screen_Pateint.dart';
import '/View/log_in.dart';
import 'package:http/http.dart' as http;
import '/main.dart';

class HomeScreenDoctor extends StatefulWidget {
  HomeScreenDoctor({Key? key, required this.id}) : super(key: key);
  final dynamic id;
  @override
  State<HomeScreenDoctor> createState() => _HomeScreenDoctorState();
}

class _HomeScreenDoctorState extends State<HomeScreenDoctor> {
  List picture = [
    "assets/f1.png",
    "assets/f2.png",
    "assets/f3.png",
    "assets/f1.png",
    "assets/f2.png",
    "assets/f3.png"
  ];
  List<MaterialColor> colors = [
    Colors.grey,
    Colors.deepOrange,
    Colors.lime,
    Colors.grey,
    Colors.deepOrange,
    Colors.lime
  ];
  int? totalUser;
  var userList;
  bool? isFirstUser;

  void initState() {
    setState(() {
      isFirstUser =
          preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser) ??
              false;
    });
    print(" isfirstUser ::  $isFirstUser");
    getAllUser();
    super.initState();
  }

  Future getAllUser() async {
    print("${widget.id}");
    http.Response response = await http.get(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/users?id=${widget.id}"),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      userList = jsonDecode(response.body);
      print("user list pateint ${jsonDecode(response.body)}");
      totalUser = userList['data'].length;
    }

    return userList;
  }

  Future addUser(name, email, mobile) async {
    int i = int.parse(mobile);
    assert(i is int);

    var body = jsonEncode(
        {"username": name, "email": email, "mobile": i, "id": widget.id});

    print("${body}");
    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/user_create"),
        body: body,
        headers: headers);

    print("${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("${jsonDecode(response.body)}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          GoogleSignIn().disconnect();
          FirebaseAuth.instance.signOut();
          return true;
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 20, 20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _width * 25,
                      ),
                      InkWell(
                        onTap: () => getAllUser(),
                        child: Image.asset(
                          "assets/logo1.png",
                          height: 80,
                          fit: BoxFit.cover,
                          width: 140,
                        ),
                      ),
                    ]),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "View Reports",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: getAllUser(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userList['data'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  height: _height * 27,
                                  width: _width * 90,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavigationHomePage(
                                                  id: userList['data'][index]
                                                      ['id'],
                                                )),
                                      );
                                    },
                                    child: Card(
                                      elevation: 5,
                                      color: colors[index][800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            picture[index],
                                            scale: 4,
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Shared By:",
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  "${userList['data'][index]['name']}",
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      radius: 13,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.analytics,
                                                          color: white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      " Reports",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(child: Text("unable"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ],
              ))),
            ],
          ),
        ),
      ),
    );
  }
}
