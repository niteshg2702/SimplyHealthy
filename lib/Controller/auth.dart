// ignore_for_file: camel_case_types, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final baseurl = "https://pdf00.herokuapp.com";

  Future createUser(name, mobileNo, pwd, email, role, speciality) async {
    var body = role == "doctor"
        ? jsonEncode({
            "username": name,
            "mobile": mobileNo,
            "email": email,
            "password": pwd,
            "role": role,
            "speciality": speciality
          })
        : jsonEncode({
            "username": name,
            "mobile": mobileNo,
            "email": email,
            "password": pwd,
            "role": role
          });

    var headers = {'content-Type': 'application/json'};


    http.Response response = await http.post(
        Uri.parse("https://pdf00.herokuapp.com/api/v1/auth/register"),
        body: body,
        headers: headers);

    print("craete user  $body");
    print(response.body.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var a = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "User Created ${a['user']['id']}");

      if (role == "patient") {
        createDefaultCollection(a['user']['id']);
      }
    } else {
      var a = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${a["error"]}");
    }
    return response.statusCode;
  }

  Future createDefaultCollection(id) async {
    var col1 =
        jsonEncode({"id": id, "l_list": [], "title": "Diagnostic Reports"});
    var col2 = jsonEncode({"id": id, "l_list": [], "title": "Prescription"});
    var col3 = jsonEncode({"id": id, "l_list": [], "title": "Bills"});
    var col4 = jsonEncode({"id": id, "l_list": [], "title": "Others"});
    var headers = {'content-Type': 'application/json'};

    http.Response response1 = await http.post(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/views/collection"),
        body: col1,
        headers: headers);
    print("coll 1 ${response1.statusCode}");
    http.Response response2 = await http.post(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/views/collection"),
        body: col2,
        headers: headers);
    print("coll 2 ${response2.statusCode}");
    http.Response response3 = await http.post(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/views/collection"),
        body: col3,
        headers: headers);
    print("coll 3 ${response3.statusCode}");
    http.Response response4 = await http.post(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/views/collection"),
        body: col4,
        headers: headers);
    print("coll 4 ${response4.statusCode}");
  }

  Future loginByMobile(mobileNo) async {
    print(mobileNo);
    var body = jsonEncode({"mobile": mobileNo});

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse("https://pdf00.herokuapp.com/api/v1/auth/login"),
        body: body,
        headers: headers);
    List list = [];
    list.insert(0, response.statusCode);
    var a = jsonDecode(response.body);
    print("login by mobile body ${response.statusCode} ${a}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      list.insert(1, a['user']['id']);
      list.insert(2, a['user']['role']);
      print("${a['user']['id']}");
    } else {
      Fluttertoast.showToast(msg: "${a["error"]}");
    }
    return list;
  }

  Future loginByGoogleSignIn(email, name) async {
    var body = jsonEncode({
      "username": name,
      "email": email,
    });
    print(body);
    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/auth/register_google"),
        body: body,
        headers: headers);
    List list = [];
    list.insert(0, response.statusCode);
    var a = jsonDecode(response.body);
    print("${response.statusCode} ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      var a = jsonDecode(response.body);
      list.insert(1, a['user']['id']);
      list.insert(2, a['user']['role']);
      print("${a['user']['id']}");
    } else {
      var a = jsonDecode(response.body);
      GoogleSignIn().disconnect();
      FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: "${a["error"]}");
    }
    return list;
  }

  Future updateUserProfile(name, mobileNo, email, id, img) async {
    var body = jsonEncode(
        {"name": name, "mobile": mobileNo, "email": email, "img": img});

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.put(
        Uri.parse(
            "https://pdf00.herokuapp.com/api/v1/views/update_patient?id=$id"),
        body: body,
        headers: headers);

    print("update user ${jsonDecode(body)} $id ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: "User Updated");
    } else {
      var a = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${a["msg"]}");
    }
    return response.statusCode;
  }

  Future submitReccomadation(body1) async {
    var body = jsonEncode(body1);

    var headers = {'content-Type': 'application/json'};

    http.Response response = await http.post(
        Uri.parse("https://pdf00.herokuapp.com/api/v1/views/questions"),
        body: body,
        headers: headers);

    print("submit recomndation ${body1} ${response.body}");

    return response.statusCode;
  }
}
