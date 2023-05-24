// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:eyebaituna_app/Auth_pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<Register> {
  //? To hide password
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: <Widget>[
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromRGBO(112, 135, 250, 1),
                  Color.fromRGBO(67, 88, 191, 1),
                ],
              )),
            ),
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Color(0xff16171a).withOpacity(.85),
                  )),
            )
          ],
        ),
        Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //? LOGO
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              SizedBox(height: 40.0),
              //? TOP SECTION
              Center(
                child: Column(children: [
                  //! Welcome-Text Field
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      textStyle: TextStyle(
                          color: Color.fromRGBO(242, 242, 250, 1),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 80, left: 80),
                    child: Text(
                      'Please enter your information to get you started',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(167, 167, 204, 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  //! Name Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(242, 242, 255, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Enter Name'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  //! Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(242, 242, 255, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Email'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  //! Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(242, 242, 255, 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          obscureText: !_obscureText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              iconSize: 20,
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromRGBO(101, 101, 118, 1),
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  //! Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: const [
                              Color.fromRGBO(157, 98, 217, 1),
                              Color.fromRGBO(98, 98, 217, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Register',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  //! Already a member?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(167, 167, 204, 1),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                        child: Text(
                          ' Sign In Now',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(242, 242, 250, 1),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ]),
          ),
        )
      ]),
    ));
  }
}
