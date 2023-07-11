// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:ui';
import 'package:eyebaituna_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:eyebaituna_app/Auth_pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<Register> {
  //? To hide password
  bool _obscureText = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _errorMessage = '';
  bool isEmailValid(String? email) {
    if (email == null) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isAnyFieldEmpty() {
    return _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) {
      return false;
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    // Check for at least one symbol
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
  }

  bool isNameValid(String name) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
    return nameRegex.hasMatch(name);
  }

  validateUserName() {
    String name = _nameController.text.trim();
    if (!isNameValid(name)) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 4,
          msg: "Name cannot contain numbers or symbols");
      return false;
    }
    return true;
  }

  validateUserEmail() async {
    try {
      final res = await http.post(Uri.parse(ApiService.validateEmail), body: {
        'email': _emailController.text.trim(),
      });
      if (res.statusCode == 200) {
        final resBodyToCheckEmail = jsonDecode(res.body);
        return !resBodyToCheckEmail[
            'emailFound']; // Return true if email is valid (not found in the database)
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 4,
          msg: "validateUserEmail IS WRONG");
    }
    return false; // Return false in case of an error or invalid response
  }

  registerNewUser() async {
    String email = _emailController.text.trim();
    if (!isEmailValid(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }
    if (!validateUserName()) {
      return;
    }
    String password = _passwordController.text.trim();
    if (!isPasswordValid(password)) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        msg:
            "Password should be at least 8 characters, including numbers, at least one uppercase letter, and at least one symbol",
      );
      return;
    }
    User userModel = User(
      id: 1,
      username: _nameController.text.trim(),
      email: email,
      password: password,
      pincode: null, // Set pincode to null explicitly
    );

    bool isValidEmail = await validateUserEmail();
    if (!isValidEmail) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        msg: 'Please choose another email',
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse(ApiService.signup),
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        final resBodyOfRegistered = jsonDecode(res.body);
        if (resBodyOfRegistered['success']) {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 4,
            msg: "Sign up confirmed",
          );
          setState(() {
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
          });
          Get.to(Login());
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
      Fluttertoast.showToast(msg: "registerNewUser IS WRONG");
    }
  }

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
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 242, 255, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Name",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //! Email Field
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 242, 255, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //! Password Field

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(242, 242, 255, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextFormField(
                                  obscureText: !_obscureText,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      suffixIcon: IconButton(
                                        iconSize: 20,
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromRGBO(101, 101, 118, 1),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //! Register Button

                          Container(
                            width: 80.w,
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (isAnyFieldEmpty()) {
                                    setState(() {
                                      _errorMessage =
                                          'Please fill in all fields';
                                    });
                                  } else {
                                    registerNewUser();
                                  }
                                },
                                child: Text(
                                  "Register",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (isAnyFieldEmpty()) SizedBox(height: 10.0),
                          Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      )),

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
