// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Item_Report extends StatefulWidget {
  const Item_Report({Key? key, required this.id}) : super(key: key);

  final int id;
  @override
  State<Item_Report> createState() => _Item_ReportState();
}

class _Item_ReportState extends State<Item_Report> {
  Future getAnalyzedImage() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/analysisImg?id=${widget.id}"),
    );
    print("get analyzed report link  ${response.statusCode} ${response.body}");

    //setState(() {
    var a = jsonDecode(response.body);
    //});

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getAnalyzedImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data['list'].length,
                    itemBuilder: (context, index) {
                      if (snapshot.data['list'].length != 0) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          height: _height * 30,
                          width: _width * 80,
                          child: Image.network(
                            snapshot.data['list'][index]['img'],
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return Center(child: Text("No Reorts"));
                      }
                    });
              } else if (snapshot.hasError) {
                return const Center(child: Text("No Internet"));
              } else {
                return Center(
                  child: Container(
                      height: 200,
                      width: 200,
                      child: Lottie.asset("assets/loader.json")),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
