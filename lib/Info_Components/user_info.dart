// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import '../user_preferences/in_app_user.dart';

class UserInfoEditor extends StatefulWidget {
  const UserInfoEditor({super.key});

  @override
  State<UserInfoEditor> createState() => _UserInfoEditorState();
}

class _UserInfoEditorState extends State<UserInfoEditor> {
  final InAppUser _inAppUser = Get.put(InAppUser());

  Widget infoCard(IconData iconData, String userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: Color.fromRGBO(228, 228, 240, 1),
                    size: 17.sp,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userData,
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(242, 242, 250, 1),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter, children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        Column(
          children: [
            Stack(children: [
              Container(
                height: 18.h,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(35, 35, 54, 1),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Iconsax.arrow_left,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              //? Avatar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 9.h),
                  width: 100.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: const [
                        Color.fromRGBO(98, 98, 217, 1),
                        Color.fromRGBO(157, 98, 217, 1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.user_octagon,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              )
            ]),
            SizedBox(
              height: 25,
            ),
            infoCard(Iconsax.user, _inAppUser.user.username),
            SizedBox(
              height: 5,
            ),
            infoCard(Icons.email_outlined, _inAppUser.user.email),
            SizedBox(
              height: 5,
            ),
            infoCard(Iconsax.tag_right, _inAppUser.user.id.toString()),
          ],
        ),
      ]),
    );
  }
}
