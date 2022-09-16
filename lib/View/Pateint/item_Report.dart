// ignore_for_file: file_names
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:simplyhealthy/View/Doctor/createBlog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:external_path/external_path.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class Item_Report extends StatefulWidget {
  const Item_Report({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<Item_Report> createState() => _Item_ReportState();
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _Item_ReportState extends State<Item_Report> {
  List<_SalesData> data = [];

  List<dynamic> vData = [];

  Future getAnalyzedImage() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://pdf00.herokuapp.com/api/v1/views/analysisImg?id=${widget.id}"),
    );
    print("get analyzed report link  ${response.statusCode} ${response.body}");

    //setState(() {
    var a = jsonDecode(response.body);
    //});

    return jsonDecode(response.body);
  }

  TableAPI() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://pdf00.herokuapp.com/api/v1/views/report?id=${widget.id}"),
    );

    print("${response.body}");

    var d = jsonDecode(response.body);

    for (int i = 0; i < d['list'].length; i++) {
      vData.add({
        "UserId": widget.id,
        "Content ": d['list'][i]['title'],
        "Readings": d['list'][i]['values']
      });
    }

    print("$vData");

    return jsonDecode(response.body);
  }

  void CreateCSV() async {
    List<List<dynamic>> rows = [];

    // print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + vData.toString());
    List<dynamic> row = [];
    row.add("UserId");
    row.add("Content");
    row.add("Readings");
    rows.add(row);
    for (int i = 0; i < vData.length; i++) {
      List<dynamic> row = [];
      print("------------" +
          vData[i]["UserId"].toString() +
          "-----------------");
      row.add((vData[i]["UserId"]).toString());
      row.add(vData[i]["Content "]);
      row.add(vData[i]["Readings"]);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    Directory? dar = await getExternalStorageDirectory();
    String fullPath = dar!.path;

    File f = File(fullPath + "/filename${widget.id.replaceAll("-", "")}.csv");
    f.writeAsString(csv);

    print("${f.path}");

    final _firebaseStorage = FirebaseStorage.instance;
    Reference reference =
        FirebaseStorage.instance.ref().child("filename${widget.id}.csv");
    UploadTask uploadTask = reference.putData(f.readAsBytesSync());

    var snapshot = await _firebaseStorage
        .ref()
        .child('CSV/${widget.id}/${DateTime.now()}.csv')
        .putFile(f);
    Fluttertoast.showToast(msg: "Reports confirmed by user");
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.01;
    double _height = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
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
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: _height * 6,
                child: ElevatedButton.icon(
                    icon: Icon(Icons.thumb_up_alt),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    label: const Text(
                      "Share Report",
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () async {
                      CreateCSV();
                      Directory? d = await getExternalStorageDirectory();
                      String Pathway =
                          '${d!.path}/filename${widget.id.replaceAll("-", "")}.csv';
                      print("Path ---> $Pathway");

                      //File(Pathway).writeAsBytesSync(bytes);
                      try {
                        await FlutterShare.shareFile(
                          title: 'Example share',
                          text: 'Example share text',
                          filePath: Pathway,
                        );
                      } catch (e) {
                        print(e);
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: TableAPI(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data["list"].length == 0) {
                        return const Center(
                          child: Text("Please Upload a Report for analysis"),
                        );
                      } else {
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: _drawTable(snapshot.data['list']),
                        );
                      }
                      // return Column(
                      //   children: [
                      //     Table(
                      //       defaultVerticalAlignment:
                      //       TableCellVerticalAlignment.middle,
                      //       columnWidths: const {
                      //         0: FlexColumnWidth(1),
                      //         1: FlexColumnWidth(3),
                      //         2: FlexColumnWidth(5),
                      //       },
                      //       defaultColumnWidth: const FlexColumnWidth(),
                      //       border: TableBorder.all(
                      //           color: Colors.black,
                      //           style: BorderStyle.solid,
                      //           borderRadius: BorderRadius.vertical(
                      //             top: Radius.circular(10),
                      //           ),
                      //           width: 2),
                      //       children: _drawTable(snapshot.data['list']),
                      //     ),
                      //   ],
                      // );
                    } else if (snapshot.hasError) {
                      return Text("unable to fetch detail");
                    } else {
                      return Text("");
                    }
                  }),
            ),
            // FutureBuilder(
            //     future: plotAnalysisGraph(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemCount: snapshot.data['list'].length,
            //             itemBuilder: (BuildContext context, int index) {
            //               List<_SalesData> l = [];
            //               for (int i = 0;
            //                   i < snapshot.data['list'][index]['values'].length;
            //                   i++) {
            //                 print("i |:| $i");
            //                 double d = double.parse(snapshot.data['list'][index]
            //                         ['values'][i]
            //                     .toString());
            //                 assert(d is double);
            //                 l.add(_SalesData(
            //                     snapshot.data['list'][index]['month'][i]
            //                         .toString(),
            //                     d));
            //               }
            //               return Column(
            //                 children: [
            //                   SfCartesianChart(
            //                       primaryXAxis: CategoryAxis(),
            //                       // Chart title
            //                       title: ChartTitle(
            //                         text: snapshot.data['list'][index]['title'],
            //                       ),
            //                       // Enable legend
            //                       legend: Legend(isVisible: false),
            //                       // Enable tooltip
            //                       tooltipBehavior:
            //                           TooltipBehavior(enable: true),
            //                       series: <ChartSeries<_SalesData, String>>[
            //                         LineSeries(
            //                             dataSource: l,
            //                             xValueMapper: (_SalesData sales, _) =>
            //                                 sales.year,
            //                             yValueMapper: (_SalesData sales, _) =>
            //                                 sales.sales,
            //                             name: 'Sales',
            //                             // Enable data label
            //                             dataLabelSettings:
            //                                 DataLabelSettings(isVisible: true))
            //                       ]),
            //                   Text(
            //                     snapshot.data['list'][index]['reportName'],
            // style: GoogleFonts.mulish(
            //     fontSize: 18, fontWeight: FontWeight.bold),
            //                   ),
            //                   Divider(
            //                     thickness: 2,
            //                   )
            //                 ],
            //               );
            //             });
            //       } else if (snapshot.hasError) {
            //         return Center(child: Text("No Data"));
            //       } else {
            //         return Text("");
            //       }
            //     }),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //   child: FutureBuilder(
            //     future: getAnalyzedImage(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //             shrinkWrap: true,
            //             physics: NeverScrollableScrollPhysics(),
            //             itemCount: snapshot.data['list'].length,
            //             itemBuilder: (context, index) {
            //               if (snapshot.data['list'].length != 0) {
            //                 return Container(
            //                   margin: EdgeInsets.all(10),
            //                   height: _height * 30,
            //                   width: _width * 80,
            //                   child: Image.network(
            //                     snapshot.data['list'][index]['img'],
            //                     fit: BoxFit.cover,
            //                   ),
            //                 );
            //               } else {
            //                 return Center(child: Text("No Reorts"));
            //               }
            //             });
            //       } else if (snapshot.hasError) {
            //         return const Center(child: Text("No Internet"));
            //       } else {
            //         return Center(
            //           child: Container(
            //               height: 200,
            //               width: 200,
            //               child: Lottie.asset("assets/loader.json")),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _drawTable(response) {
    log(response.toString());
    return List.generate(response.length, (index) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.blue,
          collapsedTextColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Text(response[index]['title'].toString()),
          children: [
            Text(
              "Values",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(response[index]['values'].length, (i) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      (i + 1).toString() + ") " + response[index]['values'][i]),
                );
              }),
            )
          ],
        ),
      );
    });
    // if (response.length == 0) {
    //   columnContent.add(TableRow(
    //     children: [
    //       Column(
    //         children: [Text("-")],
    //       ),
    //       Column(
    //         children: const [
    //           Padding(
    //             padding: const EdgeInsets.all(5.0),
    //             child: Text("-"),
    //           )
    //         ],
    //       ),
    //       Column(
    //         children: const [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text("-"),
    //           )
    //         ],
    //       )
    //     ],
    //   ));
    // }
    // for (int i = 0; i < response.length; i++) {
    //   columnContent.add(TableRow(
    //     children: [
    //       Column(
    //         children: [Text("$i")],
    //       ),
    //       Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(5.0),
    //             child: Text(response[i]['title'].toString()),
    //           )
    //         ],
    //       ),
    //       Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text(response[i]['values'].toString()),
    //           )
    //         ],
    //       )
    //     ],
    //   ));
    // }
    // return columnContent;
  }
}
