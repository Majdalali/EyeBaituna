// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:eyebaituna_app/Intro_screens/intro_one.dart';
import 'package:eyebaituna_app/Intro_screens/intro_two.dart';
import 'package:eyebaituna_app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Intro_screens/intro_three.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IntroScreen createState() => _IntroScreen();
}

class _IntroScreen extends State<IntroScreen> {
  // controller
  final PageController _controller = PageController();

  // if last page
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
        // Indicator
        Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text('Skip',
                        style: TextStyle(fontSize: 18, color: Colors.white))),
                // dot ind
                SmoothPageIndicator(controller: _controller, count: 3),

                // next & done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }));
                        },
                        child: Text('Done',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(microseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text('Next',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white))),
              ],
            ))
      ],
    ));
  }
}
