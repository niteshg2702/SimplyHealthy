// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:simplyhealthy/View/Doctor/item_d_Report.dart';

import '../Pateint/item_Report.dart';
import 'item_blogList.dart';


class BottomNavigationHomePage extends StatefulWidget {
  const BottomNavigationHomePage({Key? key, required this.id})
      : super(key: key);

  final dynamic id;
  @override
  State<BottomNavigationHomePage> createState() =>
      _BottomNavigationHomePageState();
}

class _BottomNavigationHomePageState extends State<BottomNavigationHomePage> {
  int _currentIndex = 1;

  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";
  @override
  Widget build(BuildContext context) {
    final _pageOptions = [
      ItemDReport(id: widget.id,),
      Blog(
        id: widget.id,
      )
    ];
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,

      body: WillPopScope(
        onWillPop: () async {
          
          return true;
        },
        child: Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: _height * 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo1.png",
                    scale: 3.5,
                  ),
                ],
              ),
              _pageOptions[_currentIndex],
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        elevation: 10,
        iconSize: 30.0,
        selectedColor: Color(0xff040307),
        strokeColor: Color(0x30040307),
        unSelectedColor: Color(0xffacacac),
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
          ),
          CustomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bookOpen),
          ),
          // CustomNavigationBarItem(
          //   icon: Text(""),
          //   title:Text("Camera"),
          // ),
          // CustomNavigationBarItem(
          //   icon: Icon(Icons.search),
          // ),
          // CustomNavigationBarItem(
          //   icon: Icon(Icons.account_circle),
          // ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Card(
      //               elevation: 5,
      //               shadowColor: Colors.black87,
      //               child: const Padding(
      //                 padding: EdgeInsets.all(12.0),
      //                 child: Icon(
      //                   FontAwesomeIcons.camera,
      //                   color: Colors.grey,
      //                   size: 35,
      //                 ),
      //               ),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(40),
      //               ),
      //             )
    );
  }
}
