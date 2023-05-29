// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:eyebaituna_app/Intro_screens/intro_one.dart';
import 'package:eyebaituna_app/Intro_screens/intro_two.dart';
import 'package:eyebaituna_app/Components/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Intro_screens/intro_three.dart';
import '../user_preferences/user_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroOne(),
              IntroTwo(),
              IntroThree(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          // _completeIntroScreens();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }));
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(microseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _completeIntroScreens() async {
  //   await RememberUser.setHasSeenIntroScreens(true);
  // }
}
