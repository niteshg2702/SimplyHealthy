import 'dart:convert';

MlModel mlModelFromJson(String str) => MlModel.fromJson(json.decode(str));

String mlModelToJson(MlModel data) => json.encode(data.toJson());

class MlModel {
    MlModel({
        required this.page,
    });

    List<List<Page>> page;

    factory MlModel.fromJson(Map<String, dynamic> json) => MlModel(
        page: List<List<Page>>.from(json["Page"].map((x) => List<Page>.from(x.map((x) => Page.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "Page": List<dynamic>.from(page.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    };
}

class Page {
    Page({
        required this.testName,
        required this.values,
        required this.range,
    });

    String testName;
    String values;
    String range;

    factory Page.fromJson(Map<String, dynamic> json) => Page(
        testName: json["Test Name"],
        values: json["Values"],
        range: json["Range"],
    );

    Map<String, dynamic> toJson() => {
        "Test Name": testName,
        "Values": values,
        "Range": range,
    };
}


//  int totalPage = response['table'].length;
  
//   print(totalPage);
  
//   List temp=[];
//   List values = [];
//   List Ranges=[];
//   for(int i=0 ; i<totalPage;i++){
//   response['table'][i]['0'].entries.map((e)=>temp.add(e.value.replaceAll(RegExp('[^A-Za-z]'), '').toString())).toList();
//    response['table'][i]['1'].entries.map((e)=>values.add(e.value.replaceAll(RegExp('[^0-9.]'), '').toString())).toList(); 
//     response['table'][i]['2'].entries.map((e)=>Ranges.add(e.value.replaceAll(RegExp('[^A-Za-z0-9.<>=%-]'), '').toString())).toList(); 
//   }
//   print(":: $temp");
//   print(":: $values");
//   print(":: $Ranges");
  
//   List fname=[];
//   List fvalue=[];
  
//  for(int i =0 ; i<Ranges.length;i++){
//    if(values[i].length!=0 && temp[i].length!=0){
//      if(!Ranges[i].toString().toLowerCase().contains("normal")){
//        fname.add(temp[i]);
//        fvalue.add(values[i]);
//      }
     
//    }
//  }
  
//   print(fname);
//   print(fvalue);