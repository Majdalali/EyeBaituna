// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class IntroTwo extends StatelessWidget {
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
                    padding: const EdgeInsets.only(top: 0, bottom: 20),
                    child: Image.asset(
                      "assets/images/i2.png",
                      width: 30.h,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      'Time Limits',
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(242, 242, 250, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
                    child:
                        Text('Prevent Screen Addition & Preserve Family Time',
                            textAlign: TextAlign.center,
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
