// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '/Controller/BlogAPI.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class EditBlog extends StatefulWidget {
  const EditBlog(
      {Key? key,
      required this.id,
      required this.image,
      required this.category,
      required this.readingTime,
      required this.heading,
      required this.desc})
      : super(key: key);

  final dynamic id;
  final String image;
  final String category;
  final String readingTime;
  final String heading;
  final String desc;
  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final formGlobalKey = GlobalKey<FormState>();
  List<dynamic> _category = ['cardiyology', 'Pshyco', 'Phisiyo']; // Option 2
  String _selectedCategory = 'cardiyology';
  String? readingTime;
  String? desc;
  String? title;
  String? img;
  bool isphotoloading = false;

  final picker = ImagePicker();
  File? photo;
  String? _uploadedFileURL;
  //final db = FirebaseStorage.instance;

  void initState() {
    print("id ${widget.id}");
    getAllCategory();
    Permission.photos.request();
    setState(() {
      desc = widget.desc;
      readingTime = widget.readingTime;
      _uploadedFileURL = widget.image;
      title = widget.heading;
    });
    super.initState();
  }

  Future getAllCategory() async {
    http.Response response = await http.get(Uri.parse(
        "https://pdf00.herokuapp.com/api/v1/views/user_blog_create"));

    print("${response.statusCode} ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var d = jsonDecode(response.body);
      setState(() {
        _category = d['catagories'];
        _selectedCategory = d['catagories'][0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
                Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87)),
        title: Text(
          "Add Report",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    final isValid = formGlobalKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    } else {
                      formGlobalKey.currentState!.save();

                      BlogApi blogApi = BlogApi();
                      if (_uploadedFileURL == null) {
                        Fluttertoast.showToast(msg: "Uploag Image");
                      } else {
                        await blogApi.EditBlog(
                                readingTime,
                                _selectedCategory,
                                desc,
                                title,
                                _uploadedFileURL,
                                widget.id,
                                "post")
                            .then((value) {
                          if (value == 201 || value == 201) {
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(msg: "try again");
                          }
                        });
                      }
                    }
                  },
                  child: Text(
                    "POST",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isphotoloading
                    ? Container(
                        height: _height * 25,
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        height: _height * 25,
                        child: _uploadedFileURL == null
                            ? InkWell(
                                onTap: () => uploadImage(),
                                child: const Center(
                                  child: Icon(
                                    Icons.photo,
                                    color: white,
                                    size: 60,
                                  ),
                                ),
                              )
                            : Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      _uploadedFileURL!,
                                      height: _height * 25,
                                      width: _width * 90,
                                      fit: BoxFit.cover,
                                    ))),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: black, width: 2),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Reading Time",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: readingTime,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.start,
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                  validator: (value) {
                    // final nameRegExp = RegExp(
                    //     r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

                    if (value!.isEmpty) {
                      return "Please Enter reading time";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => setState(() {
                    this.readingTime = value;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "typing...",
                    isDense: true,
                    contentPadding: EdgeInsets.all(13),
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                    errorStyle: TextStyle(color: Colors.red, height: 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Choose Category",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: col6,
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: col3, fontWeight: FontWeight.w500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: col3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: textFieldColor),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  dropdownColor: col6,
                  focusColor: col5,
                  hint: const Text(
                      'Select Category'), // Not necessary for Option 1
                  value: _selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue.toString();
                    });
                  },
                  items: _category.map((gender) {
                    return DropdownMenuItem(
                      child: Text(
                        gender,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      value: gender,
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Title",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: title,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.start,
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                  validator: (value) {
                    // final nameRegExp = RegExp(
                    //     r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

                    if (value!.length > 30) {
                      return "title length should not be grater than 30";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => setState(() {
                    this.title = value;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "heading",
                    isDense: true,
                    contentPadding: EdgeInsets.all(13),
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                    errorStyle: TextStyle(color: Colors.red, height: 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Description",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: desc,
                  maxLines: 5,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.start,
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                  validator: (value) {
                    // final nameRegExp = RegExp(
                    //     r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

                    if (value!.isEmpty) {
                      return "Please Enter Valid Name";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => setState(() {
                    this.desc = value;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "typing...",
                    isDense: true,
                    contentPadding: EdgeInsets.all(13),
                    hintStyle: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                    errorStyle: TextStyle(color: Colors.red, height: 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.getImage(source: ImageSource.gallery))!;

      setState(() {
        isphotoloading = true;
      });

      File file = File(image.path);

      if (image != null) {
        var snapshot = await _firebaseStorage
            .ref()
            .child('BlogImage/${Path.basename(image.path)}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          isphotoloading = false;
          _uploadedFileURL = downloadUrl;

          print("$_uploadedFileURL");
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }
}
