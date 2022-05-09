// ignore_for_file: prefer_typing_uninitialized_variables, unused_import
 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:simplyhealthy/View/welcome.dart';

SharedPreferences? preferences;
late final cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  WidgetsBinding.instance?.addPostFrameCallback((_) {
    print("WidgetsBinding");
  });
  SchedulerBinding.instance?.addPostFrameCallback((_) {
    print("SchedulerBinding");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simply Healthy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: const welcome(),
    );
    // home: ShareSucessScreen());
  }
}
