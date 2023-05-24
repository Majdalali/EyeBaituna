// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

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
      body: Stack(alignment: Alignment.topCenter, children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Content',
            style: TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      ]),
    );
  }
}
