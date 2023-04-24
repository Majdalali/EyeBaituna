// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class IntroThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(color: Color.fromRGBO(22, 23, 26, 1)),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: Image.asset(
                      "assets/images/i3.png",
                      height: 30.h,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      'All In One App',
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(242, 242, 250, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child:
                        Text('Everything You Need To Protect Your Loved Ones',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(228, 228, 240, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            )),
                  )
                ]),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
