// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({Key? key, required this.pdf}) : super(key: key);

  final dynamic pdf;
  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: black,
            )),
        title: Text(
          "Report Viewer",
          style: GoogleFonts.poppins(color: black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        margin: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: SfPdfViewer.network(
          widget.pdf,
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
}
