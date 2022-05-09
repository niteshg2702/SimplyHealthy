

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Controller/pdfAPI.dart';

class onlyCollectionList extends StatefulWidget {
  const onlyCollectionList(
      {Key? key,
      required this.userid,
      required this.pdfname,
      required this.pdfurl})
      : super(key: key);

  final dynamic userid;
  final dynamic pdfname;
  final dynamic pdfurl;
  @override
  State<onlyCollectionList> createState() => _onlyCollectionListState();
}

class _onlyCollectionListState extends State<onlyCollectionList> {
  PDFApi pdfApi = PDFApi();
  Map<int, bool> itemsSelectedValue = Map();

  String selectedCollectionName = "pdf";
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: Text("Select Collection",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                pdfApi
                    .addPdfInCollection(widget.userid, widget.pdfname,
                        selectedCollectionName, widget.pdfurl, "path")
                    .then((value) {
                  if (value == 200 || value == 201) {
                    Fluttertoast.showToast(msg: "Pdf Added successfully");
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                });
                // addPDFDialog();
              },
              child: Text("Post",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600))),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: pdfApi.getCollections(widget.userid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['list'].length,
                          itemBuilder: (BuildContext context, int index) {
                            bool? isCurrentIndexSelected =
                                itemsSelectedValue[index] == null
                                    ? false
                                    : itemsSelectedValue[index];

                            Card card;
                            if (isCurrentIndexSelected! == false) {
                              card = Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 160,
                                        width: 130,
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data['list'][index]['list'].length} items",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black87.withOpacity(0.8),
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black54
                                                        .withOpacity(0.5),
                                                    BlendMode.dstATop),
                                                image: const AssetImage(
                                                    "assets/pdf.png")),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data['list'][index]
                                                  ['collection'],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              snapshot.data['list'][index]
                                                      ['created']
                                                  .toString()
                                                  .split(",")[1]
                                                  .substring(0, 8),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(height: _height * 8),
                                            Center(
                                              child: Text("View Collection",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: _width * 4,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 5, 50),
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'Delete':
                                              break;
                                            case 'Rename':
                                              break;
                                          }
                                        },
                                        iconSize: 20,
                                       // splashRadius: 10,
                                        itemBuilder: (BuildContext context) {
                                          return {'Delete', 'Rename'}
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              card = Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 160,
                                        width: 130,
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data['list'][index]['list'].length} items",
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black87.withOpacity(0.8),
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black54
                                                        .withOpacity(0.5),
                                                    BlendMode.dstATop),
                                                image: const AssetImage(
                                                    "assets/pdf.png")),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data['list'][index]
                                                  ['collection'],
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.grey[800],
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              snapshot.data['list'][index]
                                                      ['created']
                                                  .toString()
                                                  .split(",")[1]
                                                  .substring(0, 8),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            SizedBox(height: _height * 8),
                                            Center(
                                              child: Text("View Collection",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: _width * 4,
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 5, 50),
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'Delete':
                                              break;
                                            case 'Rename':
                                              break;
                                          }
                                        },
                                        iconSize: 20,
                                        //splashRadius: 10,
                                        itemBuilder: (BuildContext context) {
                                          return {'Delete', 'Rename'}
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                print("selected colledtion index $index");
                                setState(() {
                                  for (int i = 0;
                                      i < snapshot.data['list'].length;
                                      i++) {
                                    if (itemsSelectedValue[i] == true) {
                                      itemsSelectedValue[i] = false;
                                    }
                                  }
                                  itemsSelectedValue[index] =
                                      !isCurrentIndexSelected;
                                  if (itemsSelectedValue[index] == true) {
                                    setState(() {
                                      print(
                                          "${snapshot.data['list'][index]['collection']}");
                                      selectedCollectionName = snapshot
                                          .data['list'][index]['collection'];
                                    });
                                  }
                                });
                              },
                              child: card,
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text("uanlbe"));
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
