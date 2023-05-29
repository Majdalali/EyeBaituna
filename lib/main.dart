// ignore_for_file: prefer_const_constructors

import 'package:eyebaituna_app/Components/home_page.dart';
import 'package:eyebaituna_app/Components/user_profile.dart';
// import 'package:eyebaituna_app/Components/intro_screen.dart';
import 'package:eyebaituna_app/Components/welcome_screen.dart';
import 'package:eyebaituna_app/models/user.dart';
import 'package:eyebaituna_app/test.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// import 'Components/splash_screen.dart';
// import 'models/user.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
          title: 'EyeBaituna',
          home: FutureBuilder(
            future: RememberUser.readUserInfo(),
            builder: (context, dataSnapShot) {
              if (dataSnapShot.data == null) {
                return WelcomeScreen();
              } else {
                return HomePage();
              }
            },
          ));
    });
  }
}
