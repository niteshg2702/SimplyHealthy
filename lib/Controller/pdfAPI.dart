// ignore_for_file: camel_case_types, file_names
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class PDFApi {
  Future createCollection(collection) async {
    var body = jsonEncode(collection);

    print("create collection body ${jsonDecode(body)}");

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/collection"),
        body: body,
        headers: headers);

    List list = [];
    list.insert(0, response.statusCode);
    list.insert(1, jsonDecode(response.body));
    print(
        "create collection stscde and response ${response.statusCode} ${response.body}");
    return list;
  }

  Future getCollections(id) async {
    http.Response response = await http.get(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id"),
    );
    print(
        "get collection list stscde and response https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id ${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

  Future uploadSinglePDF(collection, pdfname, pdfURL, id) async {
    var body1 = jsonEncode({
      "id": id,
      "pdfname": pdfname,
      "type": "pdf",
      "url": pdfURL,
      "path": "path",
    });

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse("https://psdfextracter.herokuapp.com/api/v1/views/pdf"),
        body: body1,
        headers: headers);
    print(
        "create collection by Camera stscde and response ${response.statusCode} ${response.body}");
    return response.statusCode;
  }

  Future getSinglePDF(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://psdfextracter.herokuapp.com/api/v1/views/pdf?id=${id}"));

    print("get single pdf ${response.statusCode} ${response.body}");
    return jsonDecode(response.body);
  }

  Future DeleteCollection(id) async {
    http.Response response = await http.delete(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id"),
    );

    print("delete collection ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Collection deleted");
    }
  }

  Future RenameCollection(id, name) async {
    var body = jsonEncode({"name": name});

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.put(
      Uri.parse(
          "https://psdfextracter.herokuapp.com/api/v1/views/collection?id=$id"),
      body: body,
      headers: headers,
    );

    print("Rename collection ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Collection renamed");
    }
  }

  Future RenameSinglePdf(id, name) async {
    var body1 = jsonEncode({
      "name": name,
    });
    print("$body1");
    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.put(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/pdf?id=$id"),
        body: body1,
        headers: headers);
    print("renamed single pdf ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Pdf renamed");
    }
  }

  Future DeleteSignlePdf(id) async {
    http.Response response = await http.delete(Uri.parse(
        "https://psdfextracter.herokuapp.com/api/v1/views/pdf?id=$id"));

    print(" deleted pdf ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Pdf deleted");
    }
  }

  Future DeleteSignlePdfFromCollection(id) async {
    http.Response response = await http.delete(Uri.parse(
        "https://psdfextracter.herokuapp.com/api/v1/views/pdf?id=$id"));

    print(
        "$id deleted pdf from Collection ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Pdf deleted");
    }
  }

  Future RenameSinglePdfFromCollection(id, name) async {
    var body1 = jsonEncode({
      "name": name,
    });
    print("$body1");
    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.put(
        Uri.parse(
            "https://psdfextracter.herokuapp.com/api/v1/views/pdf?id=$id"),
        body: body1,
        headers: headers);
    print(
        "renamed single pdf from collection ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Pdf renamed");
    }
  }

  Future addPdfInCollection(
      userid, pdfname, collectionName, pdfURL, path) async {
    var body1 = jsonEncode({
      "id": userid,
      "pdfname": pdfname,
      "type": collectionName,
      "url": pdfURL,
      "path": path,
    });

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse("https://psdfextracter.herokuapp.com/api/v1/views/pdf"),
        body: body1,
        headers: headers);
    print(
        "add pdf in existing collection ${response.statusCode} ${response.body}");
    return response.statusCode;
  }

  Future ShareWithDoctor(drid, patientname, pdfname, url) async {
    var body1 = jsonEncode({
      "doctor_id": drid,
      "patient_name": patientname,
      "pdfname": pdfname,
      "url": url
    });

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse("https://psdfextracter.herokuapp.com/api/v1/views/portal"),
        body: body1,
        headers: headers);
    print("share on portal  ${response.statusCode} ${response.body}");
    return response.statusCode;
  }
}
