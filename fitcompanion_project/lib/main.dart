import 'package:fitcompanion_project/screens/launch.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitCompanion App',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      home: Launch(),
    );
  }
}
