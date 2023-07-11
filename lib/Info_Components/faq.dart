// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  Widget questionCard(
    String question,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        question,
        style: GoogleFonts.inter(
            color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget answerCard(
    String answer,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4, bottom: 8),
      child: Text(
        answer,
        style: GoogleFonts.barlow(
            color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 35, 54, 1),
        title: Center(
          child: Text(
            'FAQ',
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      ),
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            questionCard('1. What is EyeBaituna?'),
            answerCard(
                'EyeBaituna is a mobile application that aims to help parents monitor and safeguard their children`s online activity.'),
            questionCard('2. How does EyeBaituna work?'),
            answerCard(
                'EyeBaituna works through a firewall that catches and block harmful websites. In addition to multiple featuers.'),
            questionCard('3. I have more questions, how to contact you?'),
            answerCard(
                'Please check the contact us page in the application in the profile or visit our website.')
          ],
        )
      ]),
    );
  }
}
