// ignore_for_file: file_names, prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '/Colors/Colors.dart';
import 'package:file_picker/file_picker.dart';
import '/Controller/pdfAPI.dart';
import '/View/Pateint/PDFViewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class Add_PDFCOllection extends StatefulWidget {
  const Add_PDFCOllection({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  final String name;
  final dynamic id;

  @override
  State<Add_PDFCOllection> createState() => _Add_PDFCOllectionState();
}

class _Add_PDFCOllectionState extends State<Add_PDFCOllection> {
  final GlobalKey<SfPdfViewerState> pdfKey = GlobalKey();
  String uploadFileURL = "none";
  File? viewfile;
  String checkURL = "";
  File? file;
  bool ispdfUploading = false;
  bool nameadded = true;
  bool flag = false;
  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  Future sendEmail() async {
    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =
        await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    if (gmailinstalled) {
      final MailOptions mailOptions = MailOptions(
        body: '',
        subject: 'Sending you PDF',
        recipients: ['example@example.com'],
        isHTML: true,
        attachments: [file!.path],
        appSchema: GMAIL_SCHEMA,
      );
      await FlutterMailer.send(mailOptions);
    }
  }

  Future<void> shareWhastup() async {
    Directory? directory = await getExternalStorageDirectory();

    print('hit ${directory!.path} / ${file!.path}');
    await WhatsappShare.shareFile(
      phone: "8160992640",
      filePath: [(file!.path)],
    );
  }

  // Future<void> isInstalled() async {
  //   final val = await WhatsappShare.isInstalled();
  //   print('Whatsapp is installed: $val');
  // }
  List pdf = [];
  List firebaseUrl = [];
  int i = 0;
  Map<String, dynamic> map = {
    // "id" : widget.id,
    // "title" : widget.name,
    "l_list": []
  };

  Map<String, dynamic> mapCOPY = {
    // "id" : widget.id,
    // "title" : widget.name,
    "l_list": [
      // {
      //   "name": "PDF Name",
      //   "url": "pdf link",
      //   "file": "file path",
      // },
      // {
      //   "name": "PDF Name2",
      //   "url": "pdf link2",
      //   "file": "file path2",
      // }
    ]
  };

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
        backgroundColor: white,
        body: Container(
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
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_outlined,
                          color: black, size: 20),
                    ),
                    Text(
                      "  ${widget.name}",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal),
                    ),
                    Flexible(
                      child: SizedBox(),
                      fit: FlexFit.tight,
                    ),
                    InkWell(
                      onTap: () {
                        PDFApi pdfApi = PDFApi();
                        pdfApi.createCollection(mapCOPY).then((value) {
                          if (value == 201 || value == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            setState(() {});
                          }
                        });
                      },
                      child: Text(
                        "Post",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    )
                    // InkWell(
                    //   onTap: () => UploadPrescription(),
                    //   child: Icon(FontAwesomeIcons.plusCircle,
                    //       color: Colors.blue, size: 22),
                    // ),
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
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: map['l_list'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 160,
                                        width: 130,
                                        child: SfPdfViewer.file(
                                          map['l_list'][index]['path'],
                                          //  SfPdfViewer.network(
                                          //   "https://firebasestorage.googleapis.com/v0/b/doctorapp-2664c.appspot.com/o/%5BCyber%20Sanjivani%20Quiz%20Certificate.pdf%5D?alt=media&token=b4d493f5-3916-4172-b63e-42a354a38b23",
                                          //key: pdfKey,
                                          pageSpacing: 0,
                                          enableDoubleTapZooming: false,
                                          initialZoomLevel: 10,

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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            map['l_list'][index]['name'],
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
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
                                                  print(
                                                      "${map['l_list'][index]['link']}");
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PDFViewer(
                                                                pdf: map['l_list']
                                                                        [index]
                                                                    ['link'],
                                                              )));
                                                  //sendEmail();
                                                },
                                                child: Icon(
                                                  Icons.photo_album_outlined,
                                                  color: Colors.grey[500],
                                                  size: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 4,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  //shareEmail();
                                                },
                                                child: Icon(
                                                  Icons.download,
                                                  color: Colors.grey[500],
                                                  size: 28,
                                                ),
                                              ),
                                              SizedBox(
                                                width: _width * 3,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  ShareDialog();
                                                  //shareEmail();
                                                },
                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.grey[500],
                                                  size: 28,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Flexible(
                                        child: SizedBox(),
                                        fit: FlexFit.tight,
                                      ),
                                      PopupMenuButton<String>(
                                        padding:
                                            EdgeInsets.fromLTRB(00, 0, 5, 50),
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
                              ),
                            );
                          })),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )),
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: InkWell(
            onTap: () {
              UploadPdfDialog();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => CameraApp()),
              // );
            },
            child: Container(
              width: _width * 35,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 2,
                  color: Color(0xFF313131),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Click on ",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                      ],
                    ),
                  )),
            )));
  }

  Future UploadPdfDialog() async {
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
                    Text(
                      widget.name,
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
                        autofocus: true,
                        autocorrect: true,
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
                          hintText: "Pdf Name",
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
                        //uploadPDFonAWS();
                        getPdfAndUpload();
                      },
                      child: Text(
                        'Select file',
                        style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    viewfile == null
                        ? Text(
                            "no selected file here ",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            viewfile!.path,
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
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
                        if (flag) {
                          Navigator.pop(context);
                          setState(() {
                            //pdf.add(file);

                            if (nameadded) {
                              map['id'] = widget.id;
                              map['title'] = widget.name;
                              mapCOPY['id'] = widget.id;
                              mapCOPY['title'] = widget.name;
                              nameadded = false;
                            }

                            map["l_list"].add({
                              "name": title.text.toString(),
                              "link": "${firebaseUrl[i]}",
                              "path": file,
                            });

                            mapCOPY["l_list"].add({
                              "name": title.text.toString(),
                              "link": "${firebaseUrl[i]}",
                              "path": "${file.toString()}"
                            });

                            print("map $i ${map['l_list'][0]}");
                            i++;
                            flag = false;
                          });
                        } else {
                          Fluttertoast.showToast(msg: "file is uploading..");
                        }
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
                      "Upload PDF",
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

  Future getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {
        this.viewfile = file;
        ispdfUploading = true;
      });
    } else {
      // User canceled the picker
    }
    String fileName = '${result!.names}}';
    print(fileName);

    final _firebaseStorage = FirebaseStorage.instance;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(file!.readAsBytesSync());

    var snapshot =
        await _firebaseStorage.ref().child('PDF/${fileName}').putFile(file!);

    var downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      flag = true;
      this.viewfile = file;
      this.uploadFileURL = downloadUrl;
      ispdfUploading = false;
      firebaseUrl.insert(i, downloadUrl);
    });
    print(" $i  ${downloadUrl}");
    return file;
  }

  Future ShareDialog() async {
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
                        } else if (_radioSelected == 1) {
                          shareWhastup();
                        } else {
                          sendEmail();
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
}
