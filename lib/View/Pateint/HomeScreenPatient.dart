import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplyhealthy/Colors/Colors.dart';
import 'package:simplyhealthy/Controller/auth.dart';
import 'package:simplyhealthy/View/Pateint/Reports.dart';
import 'package:simplyhealthy/View/Pateint/item_P_blogList.dart';
import 'package:simplyhealthy/View/Pateint/item_P_doctorList.dart';
import 'package:simplyhealthy/View/Pateint/item_Report.dart';

class HomeScreen_Patient extends StatefulWidget {
  HomeScreen_Patient({Key? key, required this.id, required this.name, required this.avatar, required this.email, required this.mobile}) : super(key: key);

  var id, avatar, name, email, mobile;

  @override
  State<HomeScreen_Patient> createState() => _HomeScreen_PatientState();
}

class _HomeScreen_PatientState extends State<HomeScreen_Patient> {

  List avtar = ["assets/f1.png", "assets/f2.png", "assets/f3.png"];
  List card = ["assets/Reports.svg", "assets/Medfora.svg", "assets/blog.svg", "assets/services.svg"];
  String? selectedAvtar;

  @override
  dynamic username, useremail, usermobile;
  void initState() {
    setState(() {
      username = widget.name;
      useremail = widget.email;
      usermobile = widget.mobile;
      selectedAvtar = widget.avatar;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 375;
    var _height = MediaQuery.of(context).size.height / 812;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
                    Opacity(
                      opacity: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.zero),
                        child: Image.asset(
                          selectedAvtar!,
                          scale: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        "assets/logo.svg",
                        height: 110,
                        width: 160,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          EditUserProfile(username, useremail, usermobile,
                              selectedAvtar, widget.id);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.zero),
                          child: Image.asset(
                            selectedAvtar!,
                            scale: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50 * _height,),
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                crossAxisCount: 2,
                children: [
                  //Reports
                  container(_height, _width, card[0], "Reports", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Reports_Dashboard(id: widget.id, name: widget.name, avatar: widget.avatar, email: widget.email, mobile: widget.mobile)));
                  }),
                  //Medfora
                  container(_height, _width, card[3], "Medfora", () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          title: const Text('Medfora'),
                          content: const Text('This content is not available right now.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                          ],
                        )
                    );
                  }),
                  //Blogs
                  container(_height, _width, card[2], "Blogs", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Item_P_BlogList(id: widget.id)));
                  }),
                  //Services
                  container(_height, _width, card[1], "Services", () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => item_P_doctorList()));
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  container(double h,double w, var image, var text,void Function() ontap) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
          height: 175 * h,
          width: 160 * w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(15 * w)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10 * h,
              ),
              SizedBox(
                height: 120 * h,
                width: 120 * h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120 * h),
                    child: SvgPicture.asset(image)
                ),
              ),
              SizedBox(
                height: 10 * h,
              ),
              Text(
                text,
                style: GoogleFonts.mulish(
                  fontSize: 18 * w,
                  fontWeight: FontWeight.w700
                ),
              )
            ],
          ),
        )
    );
  }

  Future EditUserProfile(name, email, mobile, image, id) async {
    final formGlobalKey = GlobalKey<FormState>();
    // TextEditingController _name = TextEditingController();
    // TextEditingController _email = TextEditingController();
    // TextEditingController _mobile = TextEditingController();
    String selectedAvtarLocal = image;
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
              title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedAvtarLocal = "assets/f1.png";
                              });
                            },
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: selectedAvtarLocal == "assets/f1.png"
                                  ? Colors.blue
                                  : Colors.white,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage("assets/f1.png"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedAvtarLocal = "assets/f2.png";
                              });
                            },
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: selectedAvtarLocal == "assets/f2.png"
                                  ? Colors.blue
                                  : Colors.white,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.deepOrange,
                                backgroundImage: AssetImage("assets/f2.png"),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedAvtarLocal = "assets/f3.png";
                              });
                            },
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: selectedAvtarLocal == "assets/f3.png"
                                  ? Colors.blue
                                  : Colors.white,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.lime,
                                backgroundImage: AssetImage("assets/f3.png"),
                              ),
                            ),
                          ),
                        ]);
                  }),
              //content: Text('Select where you want to capture the image from'),
              content: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Profile',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: name,
                        //controller: _name,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final nameRegExp = RegExp(r"^[a-zA-Z0-9]");

                          if (!nameRegExp.hasMatch(value.toString())) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Name",
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
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: email,
                        //controller: _email,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          final emailRegExp = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                          if (!emailRegExp.hasMatch(email.toString())) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Email",
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
                    Container(
                      height: 40,
                      width: 240,
                      child: TextFormField(
                        initialValue: mobile.toString(),
                        //controller: _mobile,
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: black),
                        validator: (value) {
                          if (value!.length != 10) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(
                            height: 0,
                          ),
                          filled: true,
                          fillColor: col6,
                          hintText: "Enter Mobile",
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: hinttextColor,
                                  fontWeight: FontWeight.w500)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: col3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textFieldColor),
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

                          final m = await int.parse(mobile.toString());
                          assert(m is int);
                          print("update ${m.runtimeType}");
                          Auth auth = Auth();
                          auth
                              .updateUserProfile(
                              name, m, email, id, selectedAvtarLocal)
                              .then((value) {
                            if (value == 201 || value == 200) {
                              setState(() {
                                selectedAvtar = selectedAvtarLocal;
                                username = name;
                                useremail = email;
                                usermobile = mobile;
                              });
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(240, 40),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
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
