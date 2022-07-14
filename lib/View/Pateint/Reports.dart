import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplyhealthy/View/Pateint/item_P_pdfList.dart';
import 'package:simplyhealthy/View/Pateint/item_Report.dart';

class Reports_Dashboard extends StatefulWidget {
  Reports_Dashboard({Key? key, required this.id, required this.name, required this.avatar, required this.email, required this.mobile}) : super(key: key);

  var id, avatar, name, email, mobile;

  @override
  State<Reports_Dashboard> createState() => _Reports_DashboardState();
}

class _Reports_DashboardState extends State<Reports_Dashboard> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 375;
    var _height = MediaQuery.of(context).size.height / 812;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _height * 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      "assets/logo.svg",
                      height: 110,
                      width: 160,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50 * _height,),
            Wrap(
              children: [
                //Upload
                container(_height, _width, title: "Upload", image: "assets/upload.png", onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => item_P_PDFList(id: widget.id, name: widget.name)));
                }),
                //Review
                container(_height, _width, title: "Review", image: "assets/review.png", onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => Item_Report(id: widget.id)));
                }),
                //Share
                container(_height, _width, title: "Share", image: "assets/share.png", onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => item_P_PDFList(id: widget.id, name: widget.name)));
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
  container(double h,double w,{var title, var image, required Function() onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffDADADA))
        ),
        height: 120 * h,
        width: 335 * w,
        margin: EdgeInsets.only(bottom: 25 * h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image),
            SizedBox(height: 10 * h,),
            Text(
              title,
              style: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w700
              ),
            )
          ],
        ),
      ),
    );
  }
}
