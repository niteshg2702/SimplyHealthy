// ignore_for_file: file_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/Colors/Colors.dart';
import '/Controller/auth.dart';
import '/Controller/sharedPreferance.dart';
import '/View/Pateint/Recommandation.dart';
import '/View/Pateint/bottomNavigationHomePatient.dart';
import '/View/log_in.dart';
import 'package:http/http.dart' as http;
import '/main.dart';


class HomeScreenPateint extends StatefulWidget {
  const HomeScreenPateint({Key? key, required this.id}) : super(key: key);

  final dynamic id;
  @override
  State<HomeScreenPateint> createState() => _HomeScreenPateintState();
}

class _HomeScreenPateintState extends State<HomeScreenPateint> {
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

  bool isEdit = false;
  int? totalUser;
  bool? isFirstUser;
  var userList;
  Auth auth = Auth();
  void initState() {
    getAllUser();
    super.initState();
  }

  Future getAllUser() async {
    setState(() {
      isFirstUser =
          preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser) ??
              false;
    });

    // print("${widget.id}");
    // print(" isfirstUser ::  $isFirstUser");
    http.Response response = await http.get(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/patients?id=${widget.id}"),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      userList = jsonDecode(response.body);

      //totalUser = userList['data'].length;
      setState(() {
        totalUser = userList['data'].length;
      });
      //print("${jsonDecode(response.body)}");
    }

    return userList;
  }

  Future addUser(name, email, mobile, avatar) async {
    int i = int.parse(mobile);
    assert(i is int);

    var body = jsonEncode({
      "username": name,
      "email": email,
      "mobile": i,
      "id": widget.id,
      "img_link": avatar
    });

   // print("${body}");
    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/patient_create"),
        body: body,
        headers: headers);

    print("${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      var parsed = jsonDecode(response.body);
      print("string ${parsed['user']['id']}");
      auth.createDefaultCollection(parsed['user']['id']);
      print("${jsonDecode(response.body)}");
    }
  }

  //final controller = Get.put<UserProfile>(UserProfile());

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
              // Expanded(
              //   child: GetX<UserProfile>(builder: (c) {
              //     return Text("${c.name}");
              //   }),
              // ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
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
                                      isFirstUser!
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Recommandation(
                                                        role: "patient",
                                                        id: userList['data']
                                                            [index]['id'],
                                                        avatar: index == 0
                                                            ? picture[index]
                                                            : userList['data']
                                                                [index]['img'],
                                                        name: userList['data']
                                                            [index]['name'],
                                                        email: userList['data']
                                                            [index]['email'],
                                                        mobile: userList['data']
                                                            [index]['mobile'],
                                                      )))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavigationPatient(
                                                        id: userList['data']
                                                            [index]['id'],
                                                        avatar: index == 0
                                                            ? picture[index]
                                                            : userList['data']
                                                                [index]['img'],
                                                        name: userList['data']
                                                            [index]['name'],
                                                        email: userList['data']
                                                            [index]['email'],
                                                        mobile: userList['data']
                                                            [index]['mobile'],
                                                      )),
                                            );
                                    },
                                    child: Card(
                                      elevation: 5,
                                      color: colors[index][800],
                                      shape: RoundedRectangleBorder(
                                        side: isEdit
                                            ? BorderSide(
                                                color: Colors.blue,
                                                width: 3,
                                              )
                                            : BorderSide.none,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            index == 0
                                                ? picture[index]
                                                : userList['data'][index]
                                                    ['img'],
                                            scale: 4,
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Text(
                                              userList['data'][index]['name'],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                              ),
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
                  InkWell(
                    onTap: () {
                      addUserDialog();
                      //addUser();
                    },
                    child: Container(
                      height: _height * 25,
                      width: _width * 90,
                      child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                    size: 35,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.blue, width: 3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              Text(
                                "Create Profile",
                                style: GoogleFonts.mulish(
                                  color: Colors.blue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ))),
                    ),
                  ),
                ],
              ))),
            ],
          ),
        ),
      ),
    );
  }

  Future addUserDialog() async {
    List avtar = ["assets/f1.png", "assets/f2.png", "assets/f3.png"];
    String selectedAvtar = "assets/f1.png";
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _mobile = TextEditingController();
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
                            selectedAvtar = "assets/f1.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtar == "assets/f1.png"
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
                            selectedAvtar = "assets/f2.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtar == "assets/f2.png"
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
                            selectedAvtar = "assets/f3.png";
                          });
                        },
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: selectedAvtar == "assets/f3.png"
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
                      'Add User',
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
                        controller: _name,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final nameRegExp = RegExp(r"^[a-zA-Z]");

                          if (!nameRegExp.hasMatch(_name.text)) {
                            return "";
                          } else {
                            return null;
                          }
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
                        controller: _email,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (!emailRegExp.hasMatch(_email.text)) {
                            return "";
                          } else {
                            return null;
                          }
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
                        controller: _mobile,
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

                          if (totalUser! < 4) {
                            addUser(_name.text, _email.text, _mobile.text,
                                selectedAvtar);
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Maximum 4 user can join");
                            Navigator.pop(context);
                          }
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
                        "Create Profile",
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
