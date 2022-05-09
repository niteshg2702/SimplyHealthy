// ignore_for_file: file_names
import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/Colors/Colors.dart';
import '/Controller/pdfAPI.dart';
import '/View/Pateint/onlyCollectionList.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key, required this.ImagePath, required this.id})
      : super(key: key);

  final File ImagePath;
  final dynamic id;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  PDFApi pdfApi = PDFApi();
  String? pdfURL;
  String? PDFfile, fileName;
  bool pdfloading = true;
  bool isfileuploaded = false;
  void initState() {
    CreatePDF();
    super.initState();
  }

  CreatePDF() {
    final image = pw.MemoryImage(widget.ImagePath.readAsBytesSync());

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context contex) {
          return pw.Center(child: pw.Image(image));
        }));

    savePDF();
  }

  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File(
          '${dir!.path}/Captured image ${DateFormat('ddMMyyyy').format(DateTime.now())}.pdf');
      await file.writeAsBytes(await pdf.save());

      print("pdf path ${file.path}");
      setState(() {
        PDFfile = file.path;
        pdfloading = false;
      });

      fileName = "${DateFormat('ddMMyy-hh').format(DateTime.now())}";
      final _firebaseStorage = FirebaseStorage.instance;
      Reference reference = FirebaseStorage.instance.ref().child(fileName!);
      UploadTask uploadTask = reference.putData(file.readAsBytesSync());

      var snapshot = await _firebaseStorage
          .ref()
          .child('Analysis/${widget.id}/${fileName}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        pdfURL = downloadUrl;
        isfileuploaded = true;
        print("${pdfURL}");
      });
      //showPrintedMessage('success', 'saved to documents');
    } catch (e) {
      //showPrintedMessage('error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: Text("PDF Viewer",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500))),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                addPDFDialog();
              },
              child: Text("Post",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600))),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: !isfileuploaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(top: 50),
              margin: EdgeInsets.all(10),
              height: double.infinity,
              width: double.infinity,
              child: pdfloading
                  ? Center(child: CircularProgressIndicator())
                  : SfPdfViewer.file(
                      File(PDFfile!),
                      pageSpacing: 0,
                      enableDoubleTapZooming: false,
                      initialZoomLevel: 0,
                      canShowScrollHead: false,
                      canShowScrollStatus: false,
                      canShowPaginationDialog: false,
                    ),
            ),
    );
  }

  Future addPDFDialog() async {
    final formGlobalKey = GlobalKey<FormState>();
    TextEditingController _name = TextEditingController();
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
              //content: Text('Select where you want to capture the image from'),
              title: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          hintText: "Enter Pdf Name",
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

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => onlyCollectionList(
                                    userid: widget.id,
                                    pdfname: _name.text,
                                    pdfurl: pdfURL,
                                  )));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 40),
                        primary: Color(0xFF000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Add in existing collection",
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        final isValid = formGlobalKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        } else {
                          formGlobalKey.currentState!.save();

                          pdfApi
                              .uploadSinglePDF(
                            _name.text,
                            fileName,
                            pdfURL,
                            widget.id,
                          )
                              .then((value) {
                            if (value == 201 || value == 200) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          });
                          // if (totalUser! < 4) {
                          //   addUser(_name.text, _email.text, _mobile.text);
                          //   Navigator.pop(context);
                          // } else {
                          //   Fluttertoast.showToast(
                          //       msg: "Maximum 4 user can join");
                          //   Navigator.pop(context);
                          // }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 40),
                        primary: Color(0xFF000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Upload PDF",
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
