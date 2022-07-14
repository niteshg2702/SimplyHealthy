// ignore_for_file: file_names, prefer_const_constructors, unrelated_type_equality_checks, unused_local_variable
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplyhealthy/Controller/sharedPreferance.dart';
import 'package:simplyhealthy/Model/MlResponseModel.dart';
import 'package:simplyhealthy/main.dart';
import '/Colors/Colors.dart';
import '/Controller/pdfAPI.dart';
import '/View/Pateint/PDFViewer.dart';
import '/View/Pateint/ShareOnPortal.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ViewPdfCollection extends StatefulWidget {
  const ViewPdfCollection({
    Key? key,
    required this.collectionName,
    required this.userid,
    required this.collectionid,
    required this.collectionPdflist,
    required this.patientname,
    required this.mode,
  }) : super(key: key);

  final dynamic collectionName;
  final dynamic userid;
  final dynamic collectionid;
  final dynamic collectionPdflist;
  final dynamic patientname;
  final String mode;
  @override
  State<ViewPdfCollection> createState() => _ViewPdfCollectionState();
}

class _ViewPdfCollectionState extends State<ViewPdfCollection> {
  final GlobalKey<SfPdfViewerState> pdfKey = GlobalKey();
  String uploadFileURL = "none";
  File? viewfile;
  String checkURL = "";
  bool nameadded = true;
  bool flag = false;
  PDFApi pdfApi = PDFApi();
  @override
  void initState() {
    super.initState();
  }

  Future sendEmail(filePath) async {
    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =
        await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    if (gmailinstalled) {
      final MailOptions mailOptions = MailOptions(
        body: '',
        subject: 'Sending you PDF',
        recipients: ['example@example.com'],
        isHTML: true,
        attachments: [filePath.toString()],
        appSchema: GMAIL_SCHEMA,
      );
      await FlutterMailer.send(mailOptions);
    }
  }

  Future<void> shareWhastup(filePath) async {
    // if (WhatsappShare.isInstalled() == true) {
    await WhatsappShare.shareFile(
      phone: "8160992640",
      filePath: [filePath],
    );
    // } else {
    //   Fluttertoast.showToast(msg: "whatsapp is not installed");
    // }
  }

  Future getColletionPdfList() async {
    print("hi");
    http.Response response = await http.get(
      Uri.parse(
          "https://pdf00.herokuapp.com/api/v1/views/coll?id=${widget.collectionid}&userid=${widget.userid}"),
    );
    // print(" hello ${response.statusCode} ${response.body}");
    // if (mounted) {
    //setState(() {
    var a = jsonDecode(response.body);
    //});
    //}ssss

    return jsonDecode(response.body);
  }

  int i = 0;
  Map<String, dynamic> map = {"l_list": []};

  Map<String, dynamic> mapCOPY = {"l_list": []};

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: _width * 5, vertical: _height * 2),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_outlined,
                          color: black, size: 20),
                    ),
                    Text(
                      "  ${widget.collectionName}",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal),
                    ),
                    Flexible(
                      child: SizedBox(),
                      fit: FlexFit.tight,
                    ),
                    InkWell(
                      onTap: () {
                        _FileShareDialog(widget.collectionName);
                        // UploadPdfDialog(widget.collectionName);
                        // PDFApi pdfApi = PDFApi();
                        // pdfApi.createCollection(mapCOPY).then((value) {
                        //   if (value == 201 || value == 200) {
                        //     Navigator.pop(context);
                        //     Navigator.pop(context);
                        //     setState(() {});
                        //   }
                        // });
                      },
                      child: Image.asset(
                        "assets/plus.png",
                        scale: 4.5,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: _width * 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: getColletionPdfList(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              print("Snapshot rebuild");
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data['list'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        child: Card(
                                          elevation: 5,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 160,
                                                  width: 130,
                                                  child: Text(""),
                                                  // SfPdfViewer.network(
                                                  //   snapshot.data['list'][index]
                                                  //       ['url'],
                                                  //   //  SfPdfViewer.network(
                                                  //   //   "https://firebasestorage.googleapis.com/v0/b/doctorapp-2664c.appspot.com/o/%5BCyber%20Sanjivani%20Quiz%20Certificate.pdf%5D?alt=media&token=b4d493f5-3916-4172-b63e-42a354a38b23",
                                                  //   //key: pdfKey,
                                                  //   pageSpacing: 0,
                                                  //   enableDoubleTapZooming:
                                                  //       false,
                                                  //   initialZoomLevel: 10,

                                                  //   canShowScrollHead: false,
                                                  //   canShowScrollStatus: false,
                                                  //   canShowPaginationDialog:
                                                  //       false,
                                                  // ),
                                                  // // child: Image.asset(
                                                  // //   "assets/pdf.png",
                                                  // //   scale: 3.5,
                                                  // // ),
                                                  decoration: BoxDecoration(
                                                      // color: Colors.black87
                                                      //     .withOpacity(0.8),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          // colorFilter:
                                                          //     ColorFilter.mode(
                                                          //         Colors
                                                          //             .black54
                                                          //             .withOpacity(
                                                          //                 0.8),
                                                          //         BlendMode
                                                          //             .dstATop),
                                                          image: const AssetImage(
                                                              "assets/reports.jpg")),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(25),
                                                        topRight:
                                                            Radius.circular(25),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot.data['list']
                                                            [index]['name'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .grey[800],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                      Text(
                                                        snapshot.data['list']
                                                                [index]
                                                                ['created']
                                                            .toString()
                                                            .split(",")[1]
                                                            .substring(0, 8),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey[500],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                      SizedBox(
                                                          height: _height * 8),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PDFViewer(
                                                                            pdf:
                                                                                snapshot.data['list'][index]['url'],
                                                                          )));
                                                              //sendEmail();
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .photo_album_outlined,
                                                              color: Colors
                                                                  .grey[500],
                                                              size: 26,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: _width * 2,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              launch(snapshot
                                                                          .data[
                                                                      'list'][
                                                                  index]['url']);
                                                              //shareEmail();
                                                            },
                                                            child: Icon(
                                                              Icons.download,
                                                              color: Colors
                                                                  .grey[500],
                                                              size: 26,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: _width * 2,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              downloadPDF(
                                                                      snapshot.data['list']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'url'],
                                                                      snapshot.data['list']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'name'])
                                                                  .then(
                                                                      (value) {
                                                                ShareDialog(
                                                                    value,
                                                                    snapshot.data['list']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    snapshot.data['list']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'url']);
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.share,
                                                              color: Colors
                                                                  .grey[500],
                                                              size: 26,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuButton<String>(
                                                  padding: EdgeInsets.fromLTRB(
                                                      00, 0, 0, 50),
                                                  onSelected: (value) {
                                                    switch (value) {
                                                      case 'Delete':
                                                        pdfApi.DeleteSignlePdfFromCollection(
                                                            snapshot.data[
                                                                        'list']
                                                                    [index]
                                                                ['pdf_id']);
                                                        Navigator.pop(context);
                                                        break;
                                                      case 'Rename':
                                                        renamePdfDialog(snapshot
                                                                .data['list']
                                                            [index]['pdf_id']);

                                                        break;
                                                    }
                                                  },
                                                  iconSize: 20,
                                                  //splashRadius: 10,
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    return {'Delete', 'Rename'}
                                                        .map((String choice) {
                                                      return PopupMenuItem<
                                                          String>(
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
                                    });
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("unable"),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

                        pdfApi.RenameSinglePdfFromCollection(id, title.text);
                        Navigator.pop(context);
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

  Future _FileShareDialog(collectionName) async {
    //String? filterLocal;
    final formGlobalKey = GlobalKey<FormState>();
    String filepath = "";
    File? sendFileAnalysis;
    TextEditingController title = TextEditingController();
    bool isfileuploading = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              //content: Text('Select where you want to capture the image from'),
              title: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collectionName,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: title,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        autofocus: true,
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
                          hintText: "Enter Pdf Name ",
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          isfileuploading = true;
                        });
                        getPdfAndUpload().then((value) {
                          print("hello dear ${value.path}");
                          setState(() {
                            sendFileAnalysis = value;
                            filepath = value.path;
                            isfileuploading = false;
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.upload_file_sharp, color: Colors.black),
                          Text(
                            '  Select file',
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // viewPrescription == null
                    //     ? Text(
                    //         "no selected file here",
                    //         style: GoogleFonts.poppins(
                    //             color: col2,
                    //             fontSize: 10,
                    //             fontWeight: FontWeight.w500),
                    //       )
                    //     :
                    isfileuploading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ))
                        : Text(
                            filepath,
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
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
                          if (widget.mode == "new") {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          pdfApi
                              .addPdfInCollection(
                                  widget.userid,
                                  title.text,
                                  collectionName,
                                  uploadFileURL,
                                  viewfile!.path.toString())
                              .then((value) {
                            if (value == 201 || value == 200) {
                              DoAnalysis(sendFileAnalysis!);
                              getColletionPdfList();
                            }
                          });
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
                        "Upload Report",
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
          });
        }));
  }

  Future DoAnalysis(File file) async {
    Dio dio = Dio();

    var client = http.Client();

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response response =
        await dio.post("http://54.197.107.221:5000/pdf", data: formData);

    print("DIO ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      MlAnalyzedREport(response.data, fileName);
    } else {
      Fluttertoast.showToast(msg: "You will get analyzed report by 24 hour");
    }
  }

  Future MlAnalyzedREport(response, fileName) async {
    int totalPage = response['table'].length;

    print("Total Number Of Page : $totalPage");

    // List heading = [];
    // List value = [];

    List temp = [];
    List values = [];
    List<Map<String, dynamic>> data = [];
    List Ranges = [];

    MLModel mlmodel;

    for (int i = 0; i < totalPage; i++) {
      if (response['table'][i].length >= 2) {
        response['table'][i]['1'].entries.map((e) {
          if (e.value.replaceAll(RegExp('[^0-9.]'), '').toString().isNotEmpty) {
            if (response['table'][i]['0'][(e.key).toString()]
                .replaceAll(RegExp('[^A-Za-z]'), '')
                .toString()
                .trim()
                .isNotEmpty) {
              values.add(
                MLModel(
                  response['table'][i]['0'][(e.key).toString()]
                      .replaceAll(RegExp('[^A-Za-z]'), '')
                      .toString()
                      .toUpperCase(),
                  e.value.replaceAll(RegExp('[^0-9.]'), '').toString(),
                  // response['table'][i]['2'][e.key],
                ),
              );
            }
          }
        }).toList();
      }
    }
    MLModel m = values[0];
    print(m.testname);
    print(m.value);
    for (MLModel element in values) {
      data.add(element.toJson());
    }
    if (data.isNotEmpty) {
      postAnalysisReport(data);
    }
  }

  postAnalysisReport(List values) async {
    Map<String, dynamic> b1 = {
      "id": widget.userid.toString(),
      "results": values
    };

    var h1 = {'Content-Type': 'application/json'};

    print("what we are sending 1 $values");

    http.Response response = await http.post(
      Uri.parse("https://pdf00.herokuapp.com/api/v1/views/report"),
      headers: h1,
      body: jsonEncode(b1),
    );

    print("Analysis Post report :: ${response.statusCode} | ${response.body}");
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      Fluttertoast.showToast(msg: 'Report Generated Successfully');
    }
  }

  Future getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    File? file;
    if (result != null) {
      file = await File(result.files.single.path!);
      setState(() {
        viewfile = file;
      });
    } else {
      // User canceled the picker
    }
    String fileName = '${result!.names}}';
    print(fileName);

    final _firebaseStorage = FirebaseStorage.instance;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(file!.readAsBytesSync());

    var snapshot = await _firebaseStorage
        .ref()
        .child('Analysis/${widget.userid}/${fileName}')
        .putFile(file);

    var downloadUrl = await snapshot.ref.getDownloadURL();
    print("${downloadUrl}");
    setState(() {
      uploadFileURL = downloadUrl;
    });

    return file;
  }

  Future downloadPDF(url, pdfname) async {
    var dio = Dio();
    Directory directory = await getTemporaryDirectory();
    //Directory dar = await getExternalStorageDirectory();
    String fullPath = directory.path + "/$pdfname.pdf";
    Response response = await dio.download(url, fullPath);

    File file1 = File(fullPath);

    print("  ${file1.path}");
    return file1.path;
  }

  Future ShareDialog(filePath, pdfname, pdfurl) async {
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareOnPortal(
                                    patient_name: widget.patientname,
                                    pdfname: pdfname,
                                    pdfurl: pdfurl,
                                  )));
                        } else if (_radioSelected == 1) {
                          shareWhastup(filePath);
                          Navigator.pop(context);
                        } else {
                          sendEmail(filePath);
                          Navigator.pop(context);
                        }
                        //Navigator.pop(context);
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
}

// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);
class MLModel {
  String testname;
  String value;
  // String range;

  MLModel(this.testname, this.value);

  Map<String, dynamic> toJson() => {
        'testname': testname,
        'value': value,
      };
}


 // MakeOneAttribute(heading, value, fileName) async {
  //   List newH = [];
  //   List newV = [];
  //   List month = [];

  //   for (int i = 0; i < heading.length; i++) {
  //     if (await heading[0].toString() != heading[i].toString()) {
  //     } else {
  //       newH.add(heading[i]);
  //       month.add(i);
  //       try {
  //         newV.add(double.parse(value[i]));
  //       } catch (e) {
  //         print(e);
  //         break;
  //       }
  //     }
  //   }
  //   print("final heading $newH");
  //   print("final value $newV");

  //   if (newV.isNotEmpty) {
  //    // postAnalysisReport(heading[0], newV, month, fileName);
  //   }
  // }


    // for (int i = 0; i < totalPage; i++) {
    //   for (int j = 0; j <= response['table'][i]['0'].length; j++) {
    //     print("page $i : ${response['table'][i].length} ");
    //     if (response['table'][i].length >= 2) {
    //       if (response['table'][i]['0']["$j"].toString().contains("-") ||
    //           response['table'][i]['0']["$j"].toString().contains("TEST")) {
    //       } else {
    //         print(
    //             "$i : $j || ${response['table'][i]['0']["${j + 1}"]} = ${response['table'][i]['1']["${j + 1}"]} ");
    //         if (response['table'][i]['0']["${j + 1}"].length != 0) {
    //           heading.add(response['table'][i]['0']["${j + 1}"]
    //               .toString()
    //               .replaceAll('/n', ''));
    //           value.add(response['table'][i]['1']["${j + 1}"]);
    //         }

    //         break;
    //       }
    //     }
    //   }
    // }
    // print(heading);
    // print(value);

    // MakeOneAttribute(heading, value, fileName);