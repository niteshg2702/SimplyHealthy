// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Colors/Colors.dart';
import '/Controller/BlogAPI.dart';
import '/View/Doctor/readMoreBlog.dart';
import '/View/Pateint/ReadBlog.dart';
import '/View/doctor/createBlog.dart';
import 'package:http/http.dart' as http;

class Item_P_BlogList extends StatefulWidget {
  const Item_P_BlogList({Key? key, required this.id}) : super(key: key);

  final dynamic id;
  @override
  State<Item_P_BlogList> createState() => Item_P_BlogListState();
}

class Category {
  String? category;
  bool? ischecked;
  Category(this.category, this.ischecked);
}

class Item_P_BlogListState extends State<Item_P_BlogList> {
  BlogApi blogApi = BlogApi();
  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";
  String blogurl = "https://psdfextracter.herokuapp.com/api/v1/views/blogs";
  List<Category> category = <Category>[
    Category('All Blogs', true),
  ];

  void initState() {
    getAllCategory();
    super.initState();
  }

  Future getAllCategory() async {
    http.Response response = await http.get(Uri.parse(
        "https://psdfextracter.herokuapp.com/api/v1/views/user_blog_create"));

    print("${response.statusCode} ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var d = jsonDecode(response.body);

      setState(() {
        for (var i = 0; i < d['catagories'].length; i++) {
          category.add(Category(d['catagories'][i], false));
        }
      });
    }
    print("category length ${category.length} ");
  }

  Future getAllBlogForUser() async {
    http.Response response = await http.get(Uri.parse(blogurl));

    print("blog list $blogurl ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

  bool selectedcategory = false;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Blogs",
                style: GoogleFonts.mulish(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: _height * 5,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: category.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: InkWell(
                        onTap: () {
                          if (category[index].ischecked == false) {
                            setState(() {
                              for (var i = 0; i < category.length; i++) {
                                if (category[i].ischecked!) {
                                  category[i].ischecked = false;
                                }
                              }
                              category[index].ischecked = true;
                              if (category[index]
                                  .category
                                  .toString()
                                  .contains("All Blogs")) {
                                blogurl =
                                    "https://psdfextracter.herokuapp.com/api/v1/views/blogs";
                              } else {
                                setState(() {
                                  blogurl =
                                      "https://psdfextracter.herokuapp.com/api/v1/views/blogs?category=${category[index].category}";
                                });
                              }
                            });
                          } else {}
                        },
                        child: Card(
                          elevation: 0,
                          color:
                              category[index].ischecked! ? Colors.blue : white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 1.5),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            child: Center(
                              child: Text(
                                category[index].category!,
                                style: GoogleFonts.mulish(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: category[index].ischecked!
                                      ? white
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getAllBlogForUser(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              snapshot.data['data'][index]
                                                  ['title'],
                                              style: GoogleFonts.mulish(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: <Widget>[
                                              Image.network(
                                                snapshot.data['data'][index]
                                                    ['img'],
                                                height: _height * 10,
                                                width: _width * 30,
                                                fit: BoxFit.cover,
                                              ),
                                              // Image.network(
                                              //   snapshot.data['data'][index]['img'],
                                              //   scale: 4.3,
                                              // ),
                                              // Card(
                                              //   elevation: 5,
                                              //   shadowColor: Colors.black87,
                                              //   child: Padding(
                                              //     padding:
                                              //         const EdgeInsets.all(2.5),
                                              //     child: Row(
                                              //       children: [
                                              //         Text(" Edit",
                                              //             style: GoogleFonts
                                              //                 .poppins(
                                              //                     fontSize: 10,
                                              //                     color: Colors
                                              //                         .blue)),
                                              //         const Icon(
                                              //           Icons.edit,
                                              //           color: Colors.blue,
                                              //           size: 10,
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              //   shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //         BorderRadius.circular(20),
                                              //   ),
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // Text(
                                      //   snapshot.data['data'][index]
                                      //       ['description'],
                                      //   style: GoogleFonts.mulish(
                                      //       color: Colors.black, fontSize: 14),
                                      //   textAlign: TextAlign.justify,
                                      // ),
                                      DescriptionTextWidget(
                                          text: snapshot.data['data'][index]
                                              ['description']),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReadBlogUser(
                                                              desc: snapshot.data[
                                                                          'data']
                                                                      [index][
                                                                  'description'],
                                                              img: snapshot
                                                                          .data[
                                                                      'data'][
                                                                  index]['img'],
                                                              readingTime: snapshot
                                                                          .data[
                                                                      'data'][index]
                                                                  [
                                                                  'description'],
                                                              title: snapshot
                                                                          .data[
                                                                      'data'][
                                                                  index]['title'],
                                                            )));
                                              },
                                              child: Text(
                                                "Read More",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("unable");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ],
        ),
        // decoration: BoxDecoration(
        //     color: Colors.grey[300],
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(16),
        //       topRight: Radius.circular(16),
        //     )),
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 130) {
      firstHalf = widget.text.substring(0, 130);
      secondHalf = widget.text.substring(130, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: secondHalf!.isEmpty
          ? Text(firstHalf!)
          : Column(
              children: <Widget>[
                Text(
                  flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                  style: GoogleFonts.mulish(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
               ],
            ),
    );
  }
}
