// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import '../services/api_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final TextEditingController _urlController = TextEditingController();
  bool isBanning = false;
  bool isValid = false;

  void banURLs() async {
    String url = _urlController.text.trim();

    if (url.isEmpty) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        msg: "Please enter a website URL",
      );

      return;
    }

    try {
      final res = await http.post(
        Uri.parse(ApiService.banURLS),
        body: {
          'url': url,
        },
      );

      if (res.statusCode == 200) {
        final resBodyOfRegistered = jsonDecode(res.body);
        if (resBodyOfRegistered['success']) {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 4,
            msg: "Website has been blocked successfully!",
          );
          setState(() {
            _urlController.clear();
            isBanning = true;
          });
          Timer(Duration(seconds: 1), () {
            setState(() {
              isBanning = false; // Reset isBanning back to false after 1 second
            });
          });
        } else {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 4,
            msg: "Please try again",
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: "banURL() IS WRONG");
    }
  }

  @override
  Widget build(BuildContext context) {
    final addCircleIcon = Icon(
      Iconsax.add_circle,
      color: Color.fromRGBO(56, 176, 0, 1),
      size: 35,
    );

    final checkMarkIcon = Icon(
      Icons.check,
      color: Color.fromRGBO(120, 120, 250, 1),
      size: 35,
    );
    final notValidIcon = Icon(
      Icons.close,
      color: Color.fromRGBO(186, 24, 27, 1),
      size: 35,
    );

    final currentSuffixIcon = isBanning ? checkMarkIcon : addCircleIcon;

    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        //? WRAPPER
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //? Hero Section
                Column(
                  children: [
                    //! Header
                    Stack(children: [
                      //! HContainer
                      Container(
                        height: 18.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: const [
                              Color.fromRGBO(116, 116, 242, 0.1),
                              Color.fromRGBO(116, 116, 242, 0.5),
                            ],
                          ),
                        ),
                      ),
                      //! HPageTitle-Dashboard
                      //! HSubTitle-WelcomeBack
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            Text('Dashboard',
                                style: GoogleFonts.sora(
                                  textStyle: TextStyle(
                                      color: Color.fromRGBO(242, 242, 250, 1),
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.normal),
                                )),
                            Text('Welcome back, User',
                                style: GoogleFonts.workSans(
                                  textStyle: TextStyle(
                                      color: Color.fromRGBO(242, 242, 250, 1),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300),
                                )),
                          ],
                        ),
                      ),
                      //! InputField
                      Container(
                        margin: EdgeInsets.only(top: 15.5.h),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(242, 242, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: TextField(
                                controller: _urlController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    border: InputBorder.none,
                                    hintText: 'Enter a website to block',
                                    hintStyle: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 1000),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          final scaleAnimation =
                                              Tween<double>(begin: 0, end: 1)
                                                  .animate(CurvedAnimation(
                                                      parent: animation,
                                                      curve: Curves.easeInOut));

                                          return ScaleTransition(
                                            scale: scaleAnimation,
                                            child: child,
                                          );
                                        },
                                        child: isValid
                                            ? notValidIcon
                                            : currentSuffixIcon,
                                      ),
                                      iconSize: 35,
                                      color: Color.fromRGBO(56, 176, 0, 1),
                                      onPressed: () {
                                        if (!isURL(
                                            _urlController.text.trim())) {
                                          Fluttertoast.showToast(
                                            toastLength: Toast.LENGTH_LONG,
                                            timeInSecForIosWeb: 4,
                                            msg: "Please enter a valid URL",
                                          );
                                          setState(() {
                                            isValid = true;
                                          });
                                          Timer(Duration(seconds: 1), () {
                                            setState(() {
                                              isValid =
                                                  false; // Reset isBanning back to false after 1 second
                                            });
                                          });
                                          return;
                                        } else {
                                          banURLs();
                                        }
                                      },
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
                //? Devices List
                Container(
                  width: 85.w,
                  height: 40.h,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(35, 35, 54, 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Devices',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(120, 120, 250, 1),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          //? Device No.
                          Container(
                            width: 90.w,
                            height: 10.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(22, 23, 26, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(4, 5),
                                    spreadRadius: -6,
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.mobile,
                                        color: Color.fromRGBO(151, 155, 176, 1),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Device`s name',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              '192.168.1.1',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Connected",
                                    style: TextStyle(
                                        color: Color.fromRGBO(56, 176, 0, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  )
                                ]),
                          ),
                          SizedBox(height: 20.0),
                          //? Device No.
                          Container(
                            width: 90.w,
                            height: 10.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(22, 23, 26, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(4, 5),
                                    spreadRadius: -6,
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.mobile,
                                        color: Color.fromRGBO(151, 155, 176, 1),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Device`s name',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              '192.168.1.1',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Connected",
                                    style: TextStyle(
                                        color: Color.fromRGBO(56, 176, 0, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  )
                                ]),
                          ),
                          SizedBox(height: 20.0),
                          //? Device No.
                          Container(
                            width: 90.w,
                            height: 10.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(22, 23, 26, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(4, 5),
                                    spreadRadius: -6,
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.mobile,
                                        color: Color.fromRGBO(151, 155, 176, 1),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Device`s name',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              '192.168.1.1',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Disconnected",
                                    style: TextStyle(
                                        color: Color.fromRGBO(186, 24, 27, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  )
                                ]),
                          ),
                          SizedBox(height: 20.0),
                          //? Device No.
                          Container(
                            width: 90.w,
                            height: 10.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(22, 23, 26, 1),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(4, 5),
                                    spreadRadius: -6,
                                    blurRadius: 12,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.mobile,
                                        color: Color.fromRGBO(151, 155, 176, 1),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Device`s name',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                            Text(
                                              '192.168.1.1',
                                              style: GoogleFonts.workSans(
                                                textStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 242, 250, 1),
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Connected",
                                    style: TextStyle(
                                        color: Color.fromRGBO(56, 176, 0, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  )
                                ]),
                          ),
                        ]),
                  ),
                ),
                //? Time Counter
                Container(
                  width: 85.w,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(35, 35, 54, 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today, May 1',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.workSans(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(120, 120, 250, 1),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2 hr 5 min',
                              style: GoogleFonts.sora(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 250, 1),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal),
                              )),
                          SizedBox(height: 8.0),
                          LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            padding: EdgeInsets.all(0),
                            barRadius: Radius.circular(20),
                            lineHeight: 7,
                            progressColor: Color.fromRGBO(18, 101, 255, 11),
                            backgroundColor: Color.fromRGBO(143, 183, 255, 1),
                            percent: 0.5,
                          )
                        ],
                      ),
                      Divider()
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
