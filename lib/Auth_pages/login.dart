// ignore_for_file: avoid_print, unused_field, prefer_final_fields

import 'dart:convert';
import 'dart:ui';
import 'package:eyebaituna_app/Auth_pages/register.dart';
import 'package:eyebaituna_app/Components/home_page.dart';
import 'package:eyebaituna_app/models/user.dart';
import 'package:get/get.dart';
import 'package:eyebaituna_app/services/api_service.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../user_preferences/in_app_user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool _obscureText = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool isEmailValid(String? email) {
    if (email == null) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isAnyFieldEmpty() {
    return _emailController.text.isEmpty || _passwordController.text.isEmpty;
  }

  signInUser() async {
    String email = _emailController.text.trim();
    if (!isEmailValid(email)) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
        msg: "Please enter a valid email",
      );
      return;
    }

    try {
      final res = await http.post(Uri.parse(ApiService.login), body: {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      });

      if (res.statusCode == 200) {
        final resBodyOfLogin = jsonDecode(res.body);

        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 2,
            msg: "Sign In confirmed",
          );

          User userInfo = User.fromJson(resBodyOfLogin["userData"]);
          await RememberUser.saveUserInfo(userInfo);

          Get.put(InAppUser()); // Register InAppUser controller
          final inAppUser = Get.find<InAppUser>();

          await inAppUser.getUserInfo(); // Fetch the user information

          // Delay the navigation until after the InAppUser instance is initialized
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAll(HomePage()); // Navigate to the HomePage
          });
        } else {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 4,
            msg: "Email or password is incorrect. Please try again!",
          );
        }
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: "Sign in method IS WRONG");
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
                    'Hello Again!',
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
                      'Welcome back you’ve been missed!',
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
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                            width: 84.w,
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
                                    signInUser();
                                  }
                                },
                                child: Text(
                                  "Sign In",
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
                            return Register();
                          }));
                        },
                        child: Text(
                          ' Sign Up Now',
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
