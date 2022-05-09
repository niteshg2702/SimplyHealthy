// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import '/Controller/pdfAPI.dart';
import '/Controller/sharedPreferance.dart';
import '/View/Doctor/bottomNavigationHomeDoctor.dart';
import '/View/Pateint/bottomNavigationHomePatient.dart';
import '/main.dart';

import '../../Controller/auth.dart';

class Recommandation extends StatefulWidget {
  const Recommandation(
      {Key? key,
      required this.id,
      required this.avatar,
      required this.role,
      required this.name,
      required this.email,
      required this.mobile})
      : super(key: key);

  final dynamic id;
  final String avatar;
  final String role;
  final dynamic name;
  final dynamic email;
  final dynamic mobile;
  @override
  State<Recommandation> createState() => _RecommandationState();
}

class _RecommandationState extends State<Recommandation> {
  final formGlobalKey = GlobalKey<FormState>();
  String _AgeRadio = "<35";

  String _GenderRadio = "male";

  String _dietRadio = "vegan";
  int _lifeStyleRadio = 0;

  String _smokingRadio = "no";

  String _alcoholRadio = "no";

  String _meditationRadio = "no";

  final List<String> _Meditation = [
    "Hypertension",
    "High cholesterol",
    "Diabetes",
    "Heart disease",
    "Stroke ",
    "Kidney disease",
    "Liver disease",
    "Autoimmune disease",
    "Lung disease ",
    "Cancer",
    "Weak bones",
    "Thyroid disease",
  ];

  final List<String> _suffer = [
    "Fatigue",
    "Weakness ",
    "Loss of appetite",
    "Excessive appetite",
    "Weight loss",
    "Weight gain",
    "Inability to sleep",
    "Swelling in the body",
    "Bleeding from any site",
    "Constipation",
    "Diarrhoea",
    "Bloating",
    "Abdominal pain",
    "Jaundice",
    "Breathlessness",
    "Palpitations/ Ghabrahat",
    "Chronic cough",
    "Nasal allergy",
    "Wheezing",
    "Burning urination",
    "Leaky urine",
    "Urination at night",
    "Skin rash",
    "Urticaria",
    "Blue patches on the body",
    "Pains in the joints",
    "Bodyaches",
    "Hair fall",
    "Brittle nails",
  ];

  final List<bool> _isCheckedMeditation = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List selectedMeditation = [];

  final List<bool> _isCheckedSuffer = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List selectedsuffer = [];
  void initState() {
    preferences?.setBool(QuestionSharedpreferance.isFirstTimeUser, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: black,
            size: 20,
          ),
        ),
        title: Text(
          "Profiler",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (widget.role == 'patient') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationPatient(
                            id: widget.id,
                            avatar: widget.avatar,
                            name: widget.name,
                            mobile: widget.mobile,
                            email: widget.email)));
                preferences?.setBool(
                    QuestionSharedpreferance.isFirstTimeUser, false);
                print(
                    "get bolo updated ${preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser)}");
              } else if (widget.role == 'doctor') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationHomePage(
                              id: widget.id,
                            )));
                preferences?.setBool(
                    QuestionSharedpreferance.isFirstTimeUser, false);
              }
            },
            child: Center(
              child: Text(
                "Skip",
                style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Would you like recommendations of what tests you need to assess your health ?",
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "1) Age",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "<35",
                        groupValue: _AgeRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _AgeRadio = value!;
                          });
                        },
                      ),
                      Text('<35',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "35-60",
                        groupValue: _AgeRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _AgeRadio = value!;
                          });
                        },
                      ),
                      Text('35-50',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: '50-65',
                        groupValue: _AgeRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _AgeRadio = value!;
                          });
                        },
                      ),
                      Text('50-65',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 13)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: '>65',
                        groupValue: _AgeRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _AgeRadio = value!;
                          });
                        },
                      ),
                      Text('>65',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              Text(
                "2) Gender",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "male",
                        groupValue: _GenderRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _GenderRadio = value!;
                          });
                        },
                      ),
                      Text('Male',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "female",
                        groupValue: _GenderRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _GenderRadio = value!;
                          });
                        },
                      ),
                      Text('Female',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "transGender",
                        groupValue: _GenderRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _GenderRadio = value!;
                          });
                        },
                      ),
                      Text('TransGender',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Text(
                "3) Dieat Preferance",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "vegan",
                        groupValue: _dietRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _dietRadio = value!;
                          });
                        },
                      ),
                      Text('Vegan',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "veg",
                        groupValue: _dietRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _dietRadio = value!;
                          });
                        },
                      ),
                      Text('Veg',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "non-veg",
                        groupValue: _dietRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _dietRadio = value!;
                          });
                        },
                      ),
                      Text('Non-Veg',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Text(
                "4) Smoking",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "yes",
                        groupValue: _smokingRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _smokingRadio = value!;
                          });
                        },
                      ),
                      Text('Yes',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "no",
                        groupValue: _smokingRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _smokingRadio = value!;
                          });
                        },
                      ),
                      Text('No',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Text(
                "5) Alcohol Consumption",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "yes",
                        groupValue: _alcoholRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _alcoholRadio = value!;
                          });
                        },
                      ),
                      Text('Yes',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "no",
                        groupValue: _alcoholRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _alcoholRadio = value!;
                          });
                        },
                      ),
                      Text('No',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Text(
                "6) Are you on Regular medication ?",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "yes",
                        groupValue: _meditationRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _meditationRadio = value!;
                          });
                        },
                      ),
                      Text('Yes',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: "no",
                        groupValue: _meditationRadio,
                        activeColor: Colors.black,
                        onChanged: (String? value) {
                          setState(() {
                            _meditationRadio = value!;
                          });
                        },
                      ),
                      Text('No',
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              _meditationRadio == 'yes'
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _Meditation.length - 1,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          activeColor: Colors.black,
                          // checkboxShape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(5)),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.all(0),
                          title: Text(_Meditation[index]),
                          value: _isCheckedMeditation[index],
                          onChanged: (val) {
                            setState(
                              () {
                                _isCheckedMeditation[index] = val!;
                                if (_isCheckedMeditation[index]) {
                                  selectedMeditation.add(_Meditation[index]);
                                } else {
                                  selectedMeditation.remove(_Meditation[index]);
                                }
                              },
                            );
                            print("Meditation ${selectedMeditation}");
                          },
                        );
                      },
                    )
                  : Text(""),
              Text(
                "7) Please tick the complaints you suffer from.",
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _suffer.length - 1,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    activeColor: Colors.black,
                    controlAffinity: ListTileControlAffinity.leading,
                    // checkboxShape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5)),
                    contentPadding: EdgeInsets.all(0),
                    title: Text(_suffer[index]),
                    value: _isCheckedSuffer[index],
                    onChanged: (val) {
                      setState(
                        () {
                          _isCheckedSuffer[index] = val!;
                          if (_isCheckedSuffer[index]) {
                            selectedsuffer.add(_suffer[index]);
                          } else {
                            selectedsuffer.remove(_suffer[index]);
                          }
                        },
                      );
                      print("suffer ${selectedsuffer}");
                    },
                  );
                },
              ),
              Text(
                "Disclaimer : ",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                "These tests are just for initial screening.  They may or may not help finding out the cause of your symptoms. If you do not reach to a conclusion or your symptoms are moderate / severe it is suggested that you see a medical professional",
                textAlign: TextAlign.justify,
                style: GoogleFonts.mulish(
                  color: Colors.black,
                  fontSize: _width * 4,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: ElevatedButton(
                    onPressed: () {
                      Auth auth = Auth();

                      var response = {
                        "id": widget.id,
                        "age": _AgeRadio,
                        "gender": _GenderRadio,
                        "diet": _dietRadio,
                        "smoking": _smokingRadio,
                        "alcohol": _alcoholRadio,
                        "regular_medication": _meditationRadio,
                        "dieases": selectedMeditation,
                        "complaints": selectedsuffer
                      };
                      auth.submitReccomadation(response).then((value) {
                        if (value == 200 || value == 201) {
                          Fluttertoast.showToast(msg: "Recoomadation Submited");
                        } else {
                          Fluttertoast.showToast(msg: "not submitted");
                        }
                      });

                      if (widget.role == 'patient') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigationPatient(
                                    id: widget.id,
                                    avatar: widget.avatar,
                                    name: widget.name,
                                    mobile: widget.mobile,
                                    email: widget.email)));
                        preferences?.setBool(
                            QuestionSharedpreferance.isFirstTimeUser, false);
                        print(
                            "get bolo updated ${preferences?.getBool(QuestionSharedpreferance.isFirstTimeUser)}");
                      } else if (widget.role == 'doctor') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavigationHomePage(
                                      id: widget.id,
                                    )));
                        preferences?.setBool(
                            QuestionSharedpreferance.isFirstTimeUser, false);
                      }
                    },
                    child: Text(
                      "Submit ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Color(0xFF313131)))))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
