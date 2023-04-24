// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class TesterScreen extends StatefulWidget {
  const TesterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TesterScreen createState() => _TesterScreen();
}

class _TesterScreen extends State<TesterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('tester'));
  }
}
