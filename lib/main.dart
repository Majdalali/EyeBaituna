// ignore_for_file: prefer_const_constructors, unused_import

import 'package:eyebaituna_app/Components/home_page.dart';
import 'package:eyebaituna_app/Components/welcome_screen.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'models/user.dart';

void main() {
  Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'EyeBaituna',
        home: FutureBuilder<User?>(
          future: RememberUser.readUserInfo(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (dataSnapShot.hasData && dataSnapShot.data != null) {
              return HomePage();
            } else {
              return WelcomeScreen();
            }
          },
        ),
      );
    });
  }
}
