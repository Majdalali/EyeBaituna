// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';
import 'package:eyebaituna_app/Dashboard_Tabs/blocked_websites.dart';
import 'package:eyebaituna_app/Dashboard_Tabs/charts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import '../Dashboard_Tabs/devices_tab.dart';
import '../Dashboard_Tabs/visited__history.dart';
import '../services/api_service.dart';
import 'package:get/get.dart';

import '../user_preferences/in_app_user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  final TextEditingController _urlController = TextEditingController();
  final InAppUser _inAppUser = Get.put(InAppUser());

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
          'user_id': _inAppUser.user.id.toString(), // Add the user ID here
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
      Fluttertoast.showToast(msg: "banURLs() IS WRONG");
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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                              Text('Welcome back, ${_inAppUser.user.username}!',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
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
                                          duration:
                                              Duration(milliseconds: 1000),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            final scaleAnimation =
                                                Tween<double>(begin: 0, end: 1)
                                                    .animate(CurvedAnimation(
                                                        parent: animation,
                                                        curve:
                                                            Curves.easeInOut));

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
                  SizedBox(height: 20.0),

                  TabBar(tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.devices,
                        color: Colors.amber,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.dashboard_sharp,
                        color: Colors.amber,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.block,
                        color: Colors.amber,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.history_toggle_off,
                        color: Colors.amber,
                      ),
                    )
                  ]),
                  Expanded(
                    child: TabBarView(children: const [
                      DevicesTab(),
                      Charts(),
                      BlockedWebsites(),
                      VisitedHistory(),
                    ]),
                  ),
                  //? Devices List

                  //? Time Counter

                  Divider()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
