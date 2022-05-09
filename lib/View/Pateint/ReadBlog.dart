// ignore_for_file: file_names
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadBlogUser extends StatefulWidget {
  const ReadBlogUser({Key? key,
      required this.img,
      required this.readingTime,
      required this.title,
      required this.desc})
      : super(key: key);

  final String img;
  final String readingTime;
  final String title;
  final String desc;

  @override
  State<ReadBlogUser> createState() => _ReadBlogUserState();
}

class _ReadBlogUserState extends State<ReadBlogUser> {
 @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: _height * 40,
              width: _width * 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("${widget.img}"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        // Card(
                        //   elevation: 5,
                        //   shadowColor: Colors.black87,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(2.5),
                        //     child: Row(
                        //       children: [
                        //         Text(" Edit ",
                        //             style: GoogleFonts.poppins(
                        //                 fontSize: 14, color: Colors.blue)),
                        //         const Icon(Icons.edit,
                        //             color: Colors.blue, size: 18),
                        //       ],
                        //     ),
                        //   ),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: _height * 10,
                    width: _width * 100,

                    color: Colors.black.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.mulish(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.bookOpen,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "5 min",
                                  style: GoogleFonts.mulish(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ]),
                    ),
                    // child: BackdropFilter(

                    //   filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    //   child: Container(
                    //     height: _height*10,
                    //     decoration:BoxDecoration(
                    //       color: Colors.grey.shade200.withOpacity(0.1)
                    //     ),
                    //   ),),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                widget.desc,
                //"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing sLorem ipsum dolor sit amet, consectetur adipiscing elit. Non lectus porta urna venenatis tempus. Adipiscing s",
                // textAlign: TextAlign.justify,
                style: GoogleFonts.mulish(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
