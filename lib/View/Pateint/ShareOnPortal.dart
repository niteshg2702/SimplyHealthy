// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import '/Controller/BlogAPI.dart';
import '/Controller/pdfAPI.dart';
import '/View/Doctor/readMoreBlog.dart';
import '/View/Pateint/ReadBlog.dart';
import '/View/Pateint/ShareSuccessScreen.dart';
import '/View/Pateint/item_P_blogList.dart';
import '/View/doctor/createBlog.dart';
import 'package:http/http.dart' as http;

class ShareOnPortal extends StatefulWidget {
  const ShareOnPortal(
      {Key? key,
      required this.pdfname,
      required this.patient_name,
      required this.pdfurl})
      : super(key: key);

  final dynamic pdfname;
  final dynamic patient_name;
  final dynamic pdfurl;
  @override
  State<ShareOnPortal> createState() => _ShareOnPortalState();
}

class _ShareOnPortalState extends State<ShareOnPortal> {
  BlogApi blogApi = BlogApi();
  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";
  String blogurl = "https://pdf-extractor-new.herokuapp.com/api/v1/views/blogs";
  List<Category> category = <Category>[
    Category('All Doctors', true),
  ];

  void initState() {
    // getAllCategory();
    super.initState();
  }

  Future getAllCategory() async {
    http.Response response = await http.get(Uri.parse(
        "https://pdf-extractor-new.herokuapp.com/api/v1/views/user_blog_create"));

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
    http.Response response = await http.get(
        Uri.parse("https://pdf-extractor-new.herokuapp.com/api/v1/views/contact"));

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 20, 20),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo1.png",
                      height: 80,
                      fit: BoxFit.cover,
                      width: 140,
                    ),
                  ]),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Share on portal",
                        style: GoogleFonts.mulish(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Container(
                    //   height: _height * 5,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       physics: BouncingScrollPhysics(),
                    //       shrinkWrap: true,
                    //       itemCount: category.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Container(
                    //           child: InkWell(
                    //             onTap: () {
                    //               if (category[index].ischecked == false) {
                    //                 setState(() {
                    //                   for (var i = 0;
                    //                       i < category.length;
                    //                       i++) {
                    //                     if (category[i].ischecked!) {
                    //                       category[i].ischecked = false;
                    //                     }
                    //                   }
                    //                   category[index].ischecked = true;
                    //                   if (category[index]
                    //                       .category
                    //                       .toString()
                    //                       .contains("All Blogs")) {
                    //                     blogurl =
                    //                         "https://pdf-extractor-new.herokuapp.com/api/v1/views/blogs";
                    //                   } else {
                    //                     setState(() {
                    //                       blogurl =
                    //                           "https://pdf-extractor-new.herokuapp.com/api/v1/views/blogs?category=${category[index].category}";
                    //                     });
                    //                   }
                    //                 });
                    //               } else {}
                    //             },
                    //             child: Card(
                    //               elevation: 0,
                    //               color: category[index].ischecked!
                    //                   ? Colors.blue
                    //                   : white,
                    //               shape: RoundedRectangleBorder(
                    //                 side: BorderSide(
                    //                     color: Colors.blue, width: 1.5),
                    //                 borderRadius: BorderRadius.circular(15.0),
                    //               ),
                    //               child: Container(
                    //                 margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
                    //                 child: Center(
                    //                   child: Text(
                    //                     category[index].category!,
                    //                     style: GoogleFonts.mulish(
                    //                       fontSize: 14,
                    //                       fontWeight: FontWeight.w600,
                    //                       color: category[index].ischecked!
                    //                           ? white
                    //                           : Colors.blue,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),
                    Expanded(
                      child: FutureBuilder(
                          future: getDoctorList(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data['contacts'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Divider(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 55,
                                                    child: Image.asset(
                                                        "assets/dr.png"),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "contact no: ${snapshot.data['contacts'][index]['mobile']}",
                                                          //"Dermatologist (10 years)",
                                                          style: GoogleFonts
                                                              .mulish(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        Text(
                                                          "${snapshot.data['contacts'][index]['email']}",
                                                          //"Consultation Fee: 800 rs",
                                                          style: GoogleFonts
                                                              .mulish(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            PDFApi pdfApi =
                                                                PDFApi();
                                                            pdfApi.ShareWithDoctor(
                                                                    snapshot.data['contacts'][index]['id'],
                                                                    widget
                                                                        .patient_name,
                                                                    widget
                                                                        .pdfname,
                                                                    widget
                                                                        .pdfurl)
                                                                .then((value) {
                                                              if (value ==
                                                                      200 ||
                                                                  value ==
                                                                      201) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const ShareSucessScreen()),
                                                                );
                                                              }
                                                            });

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
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Center(
                                                              child: Text(
                                                                "share",
                                                                style: GoogleFonts.mulish(
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Text("unable");
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                ),
                // decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(16),
                //       topRight: Radius.circular(16),
                //     )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
