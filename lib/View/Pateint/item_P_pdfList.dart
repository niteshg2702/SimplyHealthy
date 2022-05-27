// ignore_for_file: file_names, prefer_if_null_operators
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '/Colors/Colors.dart';
import '/Controller/BlogAPI.dart';
import '/Controller/pdfAPI.dart';
import '/View/Pateint/PDFViewer.dart';
import '/View/Pateint/ShareOnPortal.dart';
import '/View/Pateint/ViewPdfCollection.dart';
import '/View/Pateint/add_pdfCollection.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class item_P_PDFList extends StatefulWidget {
  const item_P_PDFList({Key? key, required this.id, required this.name})
      : super(key: key);
  final dynamic id;
  final dynamic name;
  @override
  State<item_P_PDFList> createState() => _item_P_PDFListState();
}

class _item_P_PDFListState extends State<item_P_PDFList> {
  BlogApi blogApi = BlogApi();
  PDFApi pdfApi = PDFApi();
  File? downloaedpdf;

  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";

  Map<int, bool> itemsSelectedValue = Map();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;

    Future getCollections(id) async {
      http.Response response = await http.get(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id"),
      );
      // print(
      //     "get collection list stscde and response https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id ${response.statusCode} ${response.body}");

      //setState(() {
      var a = jsonDecode(response.body);
      //});

      return jsonDecode(response.body);
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  addCollection();
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => CreateBlog(id: widget.id)));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 12,
                          child: Icon(Icons.add, size: 25, color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Upload your Report",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                      //Icon(FontAwesomeIcons.plusCircle),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              FutureBuilder(
                  future: getCollections(widget.id),
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

                            //Card card;
                            // if (isCurrentIndexSelected! == false) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => ViewPdfCollection(
                                              patientname: widget.name,
                                              collectionName:
                                                  snapshot.data['list'][index]
                                                      ['collection'],
                                              collectionid: snapshot
                                                  .data['list'][index]['id'],
                                              collectionPdflist: snapshot
                                                  .data['list'][index]['list'],
                                              userid: widget.id,
                                              mode: "old",
                                            )))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Card(
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
                                              pdfApi.DeleteCollection(snapshot
                                                  .data['list'][index]['id']);
                                              break;
                                            case 'Rename':
                                              renameCollectionDialog(snapshot
                                                  .data['list'][index]['id']);

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
                              ),
                            );
                            // } else {
                            //   card = Card(
                            //     elevation: 5,
                            //     shape: RoundedRectangleBorder(
                            //         side: const BorderSide(
                            //             color: Colors.blue, width: 2),
                            //         borderRadius: BorderRadius.circular(10)),
                            //     child: Container(
                            //       margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            //       child: Row(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Container(
                            //             height: 160,
                            //             width: 140,
                            //             child: Center(
                            //               child: Text(
                            //                 "${snapshot.data['list'][index]['list'].length} items",
                            //                 style: GoogleFonts.poppins(
                            //                     fontSize: 14,
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.normal),
                            //               ),
                            //             ),
                            //             decoration: BoxDecoration(
                            //                 color:
                            //                     Colors.black87.withOpacity(0.8),
                            //                 image: DecorationImage(
                            //                     colorFilter: ColorFilter.mode(
                            //                         Colors.black54
                            //                             .withOpacity(0.5),
                            //                         BlendMode.dstATop),
                            //                     image: const AssetImage(
                            //                         "assets/pdf.png")),
                            //                 borderRadius:
                            //                     const BorderRadius.only(
                            //                   topLeft: Radius.circular(12),
                            //                   topRight: Radius.circular(12),
                            //                 )),
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Flexible(
                            //             fit: FlexFit.tight,
                            //             flex: 4,
                            //             child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   snapshot.data['list'][index]
                            //                       ['collection'],
                            //                   style: GoogleFonts.poppins(
                            //                       fontSize: 14,
                            //                       color: Colors.grey[800],
                            //                       fontWeight:
                            //                           FontWeight.normal),
                            //                 ),
                            //                 Text(
                            //                   snapshot.data['list'][index]
                            //                           ['created']
                            //                       .toString()
                            //                       .split(",")[1]
                            //                       .substring(0, 8),
                            //                   style: GoogleFonts.poppins(
                            //                       fontSize: 12,
                            //                       color: Colors.grey[500],
                            //                       fontWeight:
                            //                           FontWeight.normal),
                            //                 ),
                            //                 SizedBox(height: _height * 8),
                            //                 Row(
                            //                   children: [
                            //                     const Icon(
                            //                       FontAwesomeIcons.plusCircle,
                            //                       color: Colors.grey,
                            //                       size: 17,
                            //                     ),
                            //                     Text("  Add Document",
                            //                         style: GoogleFonts.poppins(
                            //                             fontSize: 12,
                            //                             color: Colors.grey[500],
                            //                             fontWeight:
                            //                                 FontWeight.normal)),
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           InkWell(
                            //             onTap: () {
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ViewPdfCollection(
                            //               collectionName: snapshot
                            //                           .data[
                            //                       'list'][index]
                            //                   ['collection'],
                            //               collectionid: snapshot
                            //                       .data['list']
                            //                   [index]['id'],
                            //               collectionPdflist:
                            //                   snapshot.data[
                            //                           'list']
                            //                       [index]['list'],
                            //               userid: widget.id,
                            //             )));
                            //             },
                            //             child: Card(
                            //               shape: RoundedRectangleBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(25),
                            //               ),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(4),
                            //                 child: Icon(
                            //                   Icons.edit,
                            //                   size: 20,
                            //                   color: Colors.blue[500],
                            //                 ),
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   );
                            // }

                            // return GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       for (int i = 0;
                            //           i < snapshot.data['list'].length;
                            //           i++) {
                            //         print(
                            //             "devani $i $index ${itemsSelectedValue[i]}");
                            //         if (itemsSelectedValue[i] == true) {
                            //           itemsSelectedValue[i] = false;
                            //         }
                            //       }
                            //       itemsSelectedValue[index] =
                            //           !isCurrentIndexSelected;
                            //     });
                            //   },
                            //   child: card,
                            // );
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text(""));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              FutureBuilder(
                  future: pdfApi.getSinglePDF(widget.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['list'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 170,
                                      width: 120,
                                      child: SfPdfViewer.network(
                                        snapshot.data['list'][index]['url'],
                                        //  SfPdfViewer.network(
                                        //   "https://firebasestorage.googleapis.com/v0/b/doctorapp-2664c.appspot.com/o/%5BCyber%20Sanjivani%20Quiz%20Certificate.pdf%5D?alt=media&token=b4d493f5-3916-4172-b63e-42a354a38b23",
                                        //key: pdfKey,
                                        pageSpacing: 0,
                                        enableDoubleTapZooming: false,
                                        initialZoomLevel: 5,

                                        canShowScrollHead: false,
                                        canShowScrollStatus: false,
                                        canShowPaginationDialog: false,
                                      ),
                                      // child: Image.asset(
                                      //   "assets/pdf.png",
                                      //   scale: 3.5,
                                      // ),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      flex: 6,
                                      fit: FlexFit.tight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data['list'][index]
                                                ['pdfname'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(DateTime.now()),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(height: _height * 8),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  PDFViewer(
                                                                    pdf: snapshot.data['list']
                                                                            [
                                                                            index]
                                                                        ['url'],
                                                                  )));
                                                  //sendEmail();
                                                },
                                                child: Icon(
                                                  Icons.photo_album_outlined,
                                                  color: Colors.grey[500],
                                                  size: 26,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  launch(
                                                      "${snapshot.data['list'][index]['url']}");
                                                },
                                                child: Icon(
                                                  Icons.download,
                                                  color: Colors.grey[500],
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  downloadPDF(
                                                          snapshot.data['list']
                                                              [index]['url'],
                                                          snapshot.data['list']
                                                                  [index]
                                                              ['pdfname'])
                                                      .then((value) {
                                                    ShareDialog(
                                                        value,
                                                        snapshot.data['list']
                                                            [index]['url'],
                                                        snapshot.data['list']
                                                            [index]['pdfname']);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.grey[500],
                                                  size: 26,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Flexible(
                                      child: SizedBox(),
                                      fit: FlexFit.tight,
                                    ),
                                    // PopupMenuButton<String>(
                                    //   onSelected: handleClick,
                                    //   itemBuilder: (BuildContext context) {
                                    //     return {'Logout', 'Settings'}
                                    //         .map((String choice) {
                                    //       return PopupMenuItem<String>(
                                    //         value: choice,
                                    //         child: Text(choice),
                                    //       );
                                    //     }).toList();
                                    //   },
                                    // ),
                                    PopupMenuButton<String>(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 5, 50),
                                      onSelected: (value) {
                                        switch (value) {
                                          case 'Delete':
                                            pdfApi.DeleteSignlePdf(snapshot
                                                .data['list'][index]['id']);
                                            break;
                                          case 'Rename':
                                            renamePdfDialog(snapshot
                                                .data['list'][index]['id']);
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
                          });
                    } else if (snapshot.hasError) {
                      return Text("");
                    } else {
                      return Center(child: Text("Loading.."));
                    }
                  })
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )),
      ),
    );
  }

  Future addCollection() async {
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return Container(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              scrollable: true,
              //content: Text('Select where you want to capture the image from'),
              title: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add name for collection',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
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
                          final nameRegExp = RegExp(r"^[a-zA-Z0-9]");

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
                          hintText: "Collection 1",
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

                          var collection = {
                            "id": widget.id,
                            "title": _name.text,
                            "l_list": []
                          };

                          pdfApi.createCollection(collection).then((value) {
                            if (value[0] == 200 || value[0] == 201) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewPdfCollection(
                                      patientname: widget.name,
                                      collectionName: value[1]['collection'],
                                      userid: widget.id,
                                      mode: "new",
                                      collectionid: value[1]['id'],
                                      collectionPdflist: value[1]['list'])));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong");
                              Navigator.of(context);
                            }
                          });

                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => Add_PDFCOllection(
                          //           name: _name.text,
                          //           id: widget.id,
                          //         )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 40),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        "Next",
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ).build(context),
          );
        }));
  }

  Future ShareDialog(filepath, pdfurl, pdfname) async {
    //String? filterLocal;
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController title = TextEditingController();
    int? _radioSelected = 1;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return AlertDialog(
            scrollable: true,
            //content: Text('Select where you want to capture the image from'),
            title: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share the document on',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: _radioSelected,
                              activeColor: Colors.black,
                              onChanged: (int? value) {
                                setState(() {
                                  _radioSelected = value!;
                                });
                              },
                            ),
                            Text('Portal',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black, fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _radioSelected,
                              activeColor: Colors.black,
                              onChanged: (int? value) {
                                setState(() {
                                  _radioSelected = value!;
                                });
                              },
                            ),
                            Text('Whatsup',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black, fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: _radioSelected,
                              activeColor: Colors.black,
                              onChanged: (int? value) {
                                setState(() {
                                  _radioSelected = value!;
                                });
                              },
                            ),
                            Text('GMail',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      //getDoctorList(_speciality.text);

                      final isValid = formGlobalKey.currentState!.validate();
                      if (!isValid) {
                        return;
                      } else {
                        formGlobalKey.currentState!.save();
                        if (_radioSelected == 0) {
                          print("0000");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareOnPortal(
                                    patient_name: widget.name,
                                    pdfname: pdfname,
                                    pdfurl: pdfurl,
                                  )));
                        } else if (_radioSelected == 1) {
                          shareWhastup(filepath);
                        } else {
                          sendEmail(filepath);
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 40),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Share",
                      style: GoogleFonts.poppins(
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
          ).build(context);
        }));
    // showDialog<AlertDialog>(context: context, a);
  }

  Future renameCollectionDialog(id) async {
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController title = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return AlertDialog(
            scrollable: true,
            //content: Text('Select where you want to capture the image from'),
            title: StatefulBuilder(builder: (BuildContext context, SetState) {
              return Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: title,
                        maxLines: 1,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final nameRegExp = RegExp(r"^[a-zA-Z0-9]");

                          if (!nameRegExp.hasMatch(value!)) {
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
                          hintText: "Enter New Name",
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
              );
            }),
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

                        pdfApi.RenameCollection(id, title.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 40),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Rename Collection",
                      style: GoogleFonts.poppins(
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
          ).build(context);
        }));
    // showDialog<AlertDialog>(context: context, a);
  }

  Future renamePdfDialog(id) async {
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController title = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return AlertDialog(
            scrollable: true,
            //content: Text('Select where you want to capture the image from'),
            title: StatefulBuilder(builder: (BuildContext context, SetState) {
              return Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: title,
                        maxLines: 1,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final nameRegExp = RegExp(r"^[a-zA-Z0-9]");

                          if (!nameRegExp.hasMatch(value!)) {
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
                          hintText: "Enter New Name",
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
              );
            }),
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

                        pdfApi.RenameSinglePdf(id, title.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 40),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Rename PDF",
                      style: GoogleFonts.poppins(
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
          ).build(context);
        }));
    // showDialog<AlertDialog>(context: context, a);
  }

  Future sendEmail(file) async {
    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =
        await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    if (gmailinstalled) {
      final MailOptions mailOptions = MailOptions(
        body: '',
        subject: 'Sending you PDF',
        recipients: ['example@example.com'],
        isHTML: true,
        attachments: [file],
        appSchema: GMAIL_SCHEMA,
      );
      await FlutterMailer.send(mailOptions);
    }
  }

  Future<void> shareWhastup(file) async {
    print("whats up ${downloaedpdf!.path}");

    await WhatsappShare.shareFile(
      phone: "+918160992640",
      // linkUrl: url
      filePath: [file],
    );
  }

  Future downloadPDF(url, pdfname) async {
    var dio = Dio();
    Directory directory = await getTemporaryDirectory();
    //Directory dar = await getExternalStorageDirectory();
    String fullPath = directory.path + "/$pdfname.pdf";
    Response response = await dio.download(url, fullPath);

    File file1 = File(fullPath);

    print("  ${file1.path}");

    setState(() {
      downloaedpdf = file1;
    });
    return file1.path;
  }
}
