// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:ui';
import 'package:sizer/sizer.dart';
import 'package:eyebaituna_app/Auth_pages/register.dart';
import 'package:eyebaituna_app/Auth_pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color.fromRGBO(112, 135, 250, 1),
                Color.fromRGBO(67, 88, 191, 1),
              ],
            )),
          ),
          ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xff16171a).withOpacity(.85),
                )),
          )
        ]),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  width: 95.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: const [
                          Color.fromRGBO(112, 135, 250, 1),
                          Color.fromRGBO(67, 88, 191, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "assets/images/wlcBanner.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Column(children: [
                  Text(
                    'Welcome To EyeBaituna',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(242, 242, 250, 1),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 105, right: 105),
                    child: Text(
                      'Everything you need to protect your loved ones in one App',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(167, 167, 204, 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ]),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    },
                    child: Container(
                      width: 80.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 40.w,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(167, 167, 204, 0.70),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text('Sign In',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(35, 35, 54, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Register();
                      }));
                    },
                    child: Container(
                        width: 40.w,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 0),
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(242, 242, 250, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text('Register',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(35, 35, 54, 1),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                  ),
                ],
              ),
              const Divider()
            ])
      ],
    ));
  }
}
