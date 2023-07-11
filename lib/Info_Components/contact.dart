// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});
  Widget contactInfo(String info) {
    return Text(
      info,
      style: GoogleFonts.barlow(
          color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 35, 54, 1),
        title: Center(
          child: Text(
            'Contact Us',
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      ),
      body: Stack(alignment: Alignment.topLeft, children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8, right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please don`t hesitate to contact us for any inquiries or suggestions.',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 10),
                contactInfo('Email: support@eyebaituna.com'),
                SizedBox(height: 10),
                contactInfo(
                    'or visit our website eyebaituna.com for more info.'),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
