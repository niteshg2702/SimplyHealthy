// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import '/View/Pateint/Recommandation.dart';
import '/View/Pateint/bottomNavigationHomePatient.dart';
import '/View/Pateint/item_P_blogList.dart';
import '/View/log_in.dart';
import 'package:http/http.dart' as http;

class item_P_doctorList extends StatefulWidget {
  const item_P_doctorList({Key? key}) : super(key: key);

  @override
  State<item_P_doctorList> createState() => _item_P_doctorListState();
}

class _item_P_doctorListState extends State<item_P_doctorList> {
  List<Category> category = <Category>[
    Category('All Doctors', true),
  ];

  String drurl = "https://pdf00.herokuapp.com/api/v1/views/contact";

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
        for (var i = 0; i < d['catagories'].length; i++) {
          category.add(Category(d['catagories'][i], false));
        }
      });
    }
    print("category length ${category.length} ");
  }

  Future getDoctorList() async {
    http.Response response = await http.get(Uri.parse(drurl));

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {}
    print("${response.statusCode} ${response.body}");
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        "assets/logo.svg",
                        height: 110,
                        width: 160,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Doctors",
                    style: GoogleFonts.mulish(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                height: _height * 5,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: category.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: InkWell(
                          onTap: () {
                            if (category[index].ischecked == false) {
                              setState(() {
                                for (var i = 0; i < category.length; i++) {
                                  if (category[i].ischecked!) {
                                    category[i].ischecked = false;
                                  }
                                }
                                category[index].ischecked = true;
                                if (category[index]
                                    .category
                                    .toString()
                                    .contains("All Doctors")) {
                                  drurl =
                                  "https://pdf00.herokuapp.com/api/v1/views/contact";
                                } else {
                                  setState(() {
                                    drurl =
                                    "https://pdf00.herokuapp.com/api/v1/views/contact?category=${category[index].category}";
                                  });
                                }
                              });
                            } else {}
                          },
                          child: Card(
                            elevation: 0,
                            color: category[index].ischecked!
                                ? Colors.blue
                                : white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 2, 10, 3),
                              child: Center(
                                child: Text(
                                  category[index].category!,
                                  style: GoogleFonts.mulish(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: category[index].ischecked!
                                        ? white
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              FutureBuilder(
                  future: getDoctorList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['contacts'].length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data['contacts'].length == 0) {
                              return Center(
                                child: Text(
                                    "No doctor available with this category"),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Card(
                                    elevation: 5,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(children: [
                                        Text(
                                          snapshot.data['contacts'][index]
                                          ['name'],
                                          //"Dr. Gaurav Bhardwaj M.D (Dermatologist)",
                                          style: GoogleFonts.mulish(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            CircleAvatar(
                                              radius: 55,
                                              child:
                                              Image.asset("assets/dr.png"),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "contact no: ${snapshot.data['contacts'][index]['mobile']}",
                                                  //"Dermatologist (10 years)",
                                                  style: GoogleFonts.mulish(
                                                      fontSize: 14,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                                Text(
                                                  "${snapshot.data['contacts'][index]['email']}",
                                                  //"Consultation Fee: 800 rs",
                                                  style: GoogleFonts.mulish(
                                                      fontSize: 14,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) =>
                                                    //           const Recommandation()),
                                                    // );
                                                  },
                                                  child: Container(
                                                    height: _height * 5,
                                                    width: _width * 45,
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8)),
                                                    child: Center(
                                                      child: Text(
                                                        "Recommnadtion",
                                                        style:
                                                        GoogleFonts.mulish(
                                                            fontSize: 15,
                                                            color: white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ]),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              );
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text("uanble"));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
