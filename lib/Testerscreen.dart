// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:eyebaituna_app/models/user.dart';
import 'package:eyebaituna_app/test.dart';
import 'package:flutter/material.dart';
import 'package:eyebaituna_app/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'Auth_pages/register.dart';

class TesterScreen extends StatefulWidget {
  const TesterScreen({Key? key}) : super(key: key);

  @override
  _TesterScreenState createState() => _TesterScreenState();
}

class _TesterScreenState extends State<TesterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  validateUserEmail() async {
    try {
      final res = await http.post(Uri.parse(ApiService.validateEmail), body: {
        'email': _emailController.text.trim(),
      });
      if (res.statusCode == 200) {
        final resBodyToCheckEmail = jsonDecode(res.body);
        if (resBodyToCheckEmail['emailFound']) {
          Fluttertoast.showToast(msg: 'Please choose another email');
        } else {
          // registration function
          registerNewUser();
        }
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: "validateUserEmail IS WRONG");
    }
  }

  registerNewUser() async {
    User userModel = User(
      1,
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    try {
      final res = await http.post(Uri.parse(ApiService.signup),
          body: userModel.toJson());
      if (res.statusCode == 200) {
        final resBodyOfRegistered = jsonDecode(res.body);
        if (resBodyOfRegistered['success']) {
          Fluttertoast.showToast(msg: "Sign up confirmed");
        } else {
          Fluttertoast.showToast(msg: "Please try again");
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (val) =>
                            val == "" ? "Please enter an name" : null,
                        decoration: InputDecoration(hintText: "Enter name."),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (val) =>
                            val == "" ? "Please enter an email" : null,
                        decoration: InputDecoration(hintText: "Enter email."),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (val) =>
                            val == "" ? "Please enter an passworrd" : null,
                        decoration:
                            InputDecoration(hintText: "Enter passworrd."),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        color: Colors.black,
                        child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                validateUserEmail();
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 28),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Register();
                          }));
                        },
                        child: Text(
                          ' Register Now',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Tester();
                          }));
                        },
                        child: Text(
                          ' Tester',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
