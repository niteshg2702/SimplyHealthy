import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplyhealthy/Colors/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:simplyhealthy/View/Pateint/PDFViewer.dart';

class ItemDReport extends StatefulWidget {
  const ItemDReport({Key? key, required this.id}) : super(key: key);

  final int id;
  @override
  State<ItemDReport> createState() => _ItemDReportState();
}
// https://psdfextracter.herokuapp.com/api/v1/views/portal?id=${widget.id} 
class _ItemDReportState extends State<ItemDReport> {
  Future GetReportList() async {
    http.Response response = await http.get(Uri.parse(
        "https://psdfextracter.herokuapp.com/api/v1/views/portal?id=${widget.id}"));

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {}
    print("${response.statusCode} ${response.body}");
    return jsonDecode(response.body);
  }

  List l = ["All Reports", "Latetest Reports"];
  int i = 0;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Share on portal",
                        style: GoogleFonts.mulish(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          if (i == 0) {
                            setState(() {
                              i = 1;
                            });
                          } else {
                            setState(() {
                              i = 0;
                            });
                          }
                        },
                        child: Text(
                          l[i],
                          style: GoogleFonts.mulish(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                      future: GetReportList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Map map;
                        if (i == 0) {
                          map = {"list": []};
                          map.addEntries({});
                        } else {
                          map = snapshot.data;
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: map['list'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Card(
                                      elevation: 5,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(children: [
                                          Text(
                                            map['list'][index]['patientname'],
                                            //"Dr. Gaurav Bhardwaj M.D. (Dermatologist)",
                                            style: GoogleFonts.mulish(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 55,
                                                child: Image.asset(
                                                    "assets/reports.jpg"),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Report Name :- ",
                                                      //"Dermatologist (10 years)",
                                                      style: GoogleFonts.mulish(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${map['list'][index]['pdfname']}",
                                                      //"Consultation Fee: 800 rs",
                                                      style: GoogleFonts.mulish(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[500],
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      PDFViewer(
                                                                        pdf: snapshot.data['list'][index]
                                                                            [
                                                                            'url'],
                                                                      )),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: _height * 5,
                                                        width: _width * 45,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Center(
                                                          child: Text(
                                                            "Open Report",
                                                            style: GoogleFonts
                                                                .mulish(
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
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ]),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Text("unable");
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ],
              ),
              // decoration: BoxDecoration(
              //     color: Colors.grey[300],
              //     borderRadius: const BorderRadius.only(
              //       topLeft: Radius.circular(16),
              //       topRight: Radius.circular(16),
              //     )),
            ),
          ],
        ),
      ),
    );
  }
}
