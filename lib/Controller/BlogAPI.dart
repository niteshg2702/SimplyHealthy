// ignore_for_file: camel_case_types, file_names
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '/View/Doctor/EditBlog.dart';

class BlogApi {
  Future CreateBlog(
      readingHour, category, desc, title, drname, id, img_link, type) async {
    var body = jsonEncode({
      "reading_time": readingHour,
      "category": category,
      "description": desc,
      "title": title,
      "dr_name": drname,
      "id": id,
      "im_link": img_link,
      "type": type
    });

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse(
            "https://pdf-kylo.herokuapp.com/api/v1/views/user_blog_create"),
        body: body,
        headers: headers);

    print("create blog  $body ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Blog Created");
    } else {
      var a = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${a["error"]}");
    }
    return response.statusCode;
  }

  Future getAllBlog(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://pdf-kylo.herokuapp.com/api/v1/views/all_posts?id=$id"));

    print("${response.statusCode} ${response.body}");

    return jsonDecode(response.body);
  }

// ignore: non_constant_identifier_names
  Future  EditBlog(
      readingTime, category, desc, title, img_link, id, type) async {
    var body = jsonEncode({
      "reading_time": readingTime,
      "category": category,
      "description": desc,
      "title": title,
      "img_link": img_link,
      "type": type
    });

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.put(
        Uri.parse(
            "https://pdf-kylo.herokuapp.com/api/v1/views/user_blog_create?id=$id"),
        body: body,
        headers: headers);

    print("created blog  $body ${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Blog Updated");
    } else {
      var a = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${a["error"]}");
    }
    return response.statusCode;
  }
}
