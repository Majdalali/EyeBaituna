// ignore_for_file: prefer_const_constructors

// import 'package:eyebaituna_app/Testerscreen.dart';
// import 'package:eyebaituna_app/Auth_pages/login.dart';
import 'package:eyebaituna_app/Components/home_page.dart';
import 'package:eyebaituna_app/Components/user_profile.dart';
import 'package:flutter/material.dart';
import 'Components/intro_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'EyeBaituna',
        home: IntroScreen(),
      );
    });
  }
}
