// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import '/Controller/BlogAPI.dart';
import '/View/Doctor/EditBlog.dart';
import '/View/Doctor/draftBlog.dart';
import '/View/Doctor/readMoreBlog.dart';
import '/View/doctor/createBlog.dart';

import 'package:http/http.dart' as http;

class Blog extends StatefulWidget {
  const Blog({Key? key, required this.id}) : super(key: key);

  final dynamic id;
  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  BlogApi blogApi = BlogApi();
  String desc =
      "f Minister Uddhav Thackeray is likely to take a final decision on reimposing lockdown after a cabinet meeting on April 14......";

  Future getAllBlog(id) async {
    // print("111 222 ${widget.id}}");
    http.Response response = await http.get(Uri.parse(
        "https://pdf-kylo.herokuapp.com/api/v1/views/all_posts?id=${widget.id}"));

    //print("get blog particular doctor ${response.statusCode} ${response.body}");
    setState(() {
      //var d = jsonDecode(response.body);
    });
    var d = jsonDecode(response.body);
    print("$d");
    return d;
  }

  Future getDraftBlog(id) async {
    // print("111 222 ${widget.id}}");
    http.Response response = await http.get(Uri.parse(
        "https://pdf-kylo.herokuapp.com/api/v1/views/drafts?id=${widget.id}"));

    // print(
    //     "draft blog particular doctor ${response.statusCode} ${response.body}");

    var d = jsonDecode(response.body);
    //print("$d");
    return d;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateBlog(id: widget.id)));
                },
                child: Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12,
                          child: Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Craete a New Blog",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                      //Icon(FontAwesomeIcons.plusCircle),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              FutureBuilder(
                  future: getAllBlog(widget.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // print("Snapshot blog ${snapshot.data} ");
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data['data'].length != 0) {
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
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => EditBlog(
                                                            category: snapshot.data['data']
                                                                    [index]
                                                                ['catagory'],
                                                            id: snapshot.data['data']
                                                                [index]['id'],
                                                            image: snapshot.data['data']
                                                                [index]['img'],
                                                            readingTime: snapshot.data['data']
                                                                [index]['reading_time'].toString(),
                                                            heading: snapshot.data['data']
                                                                    [index]
                                                                ['title'],
                                                            desc: snapshot.data['data']
                                                                    [index]
                                                                ['description'])));
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    shadowColor: Colors.black87,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.5),
                                                      child: Row(
                                                        children: [
                                                          Text(" Edit",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .blue)),
                                                          const Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                            size: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                )
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
                                        //       color: Colors.black,
                                        //       fontSize: 14),
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
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  ReadMoreBlog(
                                                                    type:
                                                                        "post",
                                                                    category: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'catagory'],
                                                                    id: snapshot
                                                                            .data['data']
                                                                        [
                                                                        index]['id'],
                                                                    desc: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'description'],
                                                                    img: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        ['img'],
                                                                    readingTime:
                                                                        snapshot.data['data'][index]
                                                                            [
                                                                            'reading_time'].toString(),
                                                                    title: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'title'],
                                                                  )));
                                                },
                                                child: const Text(
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
                            } else {
                              return Center(child: Text("No Blogs"));
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text("unable to fetch blog"));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              FutureBuilder(
                  future: getDraftBlog(widget.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //print("drft snp blog ${snapshot.data} ");
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data['data'].length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data['data'].length != 0) {
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
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => DraftBlog(
                                                            category: snapshot.data['data']
                                                                    [index]
                                                                ['catagory'],
                                                            id: snapshot.data['data']
                                                                [index]['id'],
                                                            image: snapshot.data['data']
                                                                [index]['img'],
                                                            readingTime:
                                                                snapshot.data['data']
                                                                [index]['id'].toString(),
                                                            heading:
                                                                snapshot.data['data']
                                                                        [index]
                                                                    ['title'],
                                                            desc: snapshot.data['data']
                                                                    [index]
                                                                ['description'])));
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    shadowColor: Colors.black87,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.5),
                                                      child: Row(
                                                        children: [
                                                          Text(" Edit",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .blue)),
                                                          const Icon(
                                                            Icons.edit,
                                                            color: Colors.blue,
                                                            size: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
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
                                                          builder:
                                                              (context) =>
                                                                  ReadMoreBlog(
                                                                    type:
                                                                        "draft",
                                                                    category: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'catagory'],
                                                                    id: snapshot
                                                                            .data['data']
                                                                        [
                                                                        index]['id'],
                                                                    desc: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'description'],
                                                                    img: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        ['img'],
                                                                    readingTime:
                                                                        snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        ['id'].toString(),
                                                                    title: snapshot.data['data']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'title'],
                                                                  )));
                                                },
                                                child: const Text(
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
                            } else {
                              return Center(child: Text("No Blogs"));
                            }
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text("unable to fetch blog"));
                    } else {
                      return Center(child: Text("Loading.."));
                    }
                  }),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )),
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

    if (widget.text.length > 110) {
      firstHalf = widget.text.substring(0, 110);
      secondHalf = widget.text.substring(110, widget.text.length);
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                  style: GoogleFonts.mulish(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                // InkWell(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: <Widget>[
                //       Text(
                //         flag ? "(read more)" : "(read less)",
                //         style:
                //             const TextStyle(color: Colors.blue, fontSize: 12),
                //       ),
                //     ],
                //   ),
                //   onTap: () {
                //     setState(() {
                //       flag = !flag;
                //     });
                //   },
                // ),
              ],
            ),
    );
  }
}
