import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareSucessScreen extends StatelessWidget {
  const ShareSucessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
          SizedBox(
            height: _height * 17,
          ),
          Image.asset(
            "assets/Group.png",
            scale: 3.5,
          ),
          Text(
            "Document Shared on",
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.normal),
          ),
          Text(
            "portal Successfully",
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
