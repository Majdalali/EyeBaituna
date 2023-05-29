// ignore_for_file: prefer_const_constructors

import 'package:eyebaituna_app/Components/welcome_screen.dart';
import 'package:eyebaituna_app/Info_Components/contact.dart';
import 'package:eyebaituna_app/Info_Components/faq.dart';
import 'package:eyebaituna_app/Info_Components/user_info.dart';
import 'package:eyebaituna_app/user_preferences/in_app_user.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  final InAppUser _inAppUser = Get.put(InAppUser());

  signOutUser() async {
    RememberUser.removeUserInfo().then((value) {
      Get.off(WelcomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //? Profile section
            Column(
              children: [
                //? Profile Banner
                Stack(children: [
                  Container(
                    height: 18.h,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(35, 35, 54, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
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
                SizedBox(height: 10.0),
                //? Name
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_inAppUser.user.username,
                          style: GoogleFonts.sora(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(242, 242, 250, 1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.normal),
                          )),
                      //? Signout & Edit
                      SizedBox(height: 14.0),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 1.0),
                              child: TextButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title:
                                        const Text('You are about to sign out'),
                                    content: const Text(
                                        'Are you sure you want to sign out?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => signOutUser(),
                                        child: const Text(
                                          'Sign out',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Iconsax.logout,
                                      color: Color.fromRGBO(242, 242, 250, 1),
                                      size: 19.sp,
                                    ),
                                    SizedBox(height: 2.0),
                                    Text('Sign out',
                                        style: GoogleFonts.workSans(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 250, 1),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w200),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return UserInfoEditor();
                                  }));
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Iconsax.user_edit,
                                      color: Color.fromRGBO(242, 242, 250, 1),
                                      size: 19.sp,
                                    ),
                                    SizedBox(height: 2.0),
                                    Text('Edit',
                                        style: GoogleFonts.workSans(
                                          textStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  242, 242, 250, 1),
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w200),
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                //? Device Info
                Container(
                  height: 8.h,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.tag_right,
                              color: Color.fromRGBO(228, 228, 240, 1),
                              size: 19.sp,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Device No.',
                                      style: GoogleFonts.workSans(
                                        textStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                242, 242, 250, 1),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.normal),
                                      )),
                                  Text('023482427187128',
                                      style: GoogleFonts.workSans(
                                        textStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                242, 242, 250, 1),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w200),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                        Text('Online',
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(120, 120, 250, 1),
                                fontSize: 13.sp,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),

            //? Settings section
            Column(
              children: [
                Container(
                  height: 8.h,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.setting,
                                color: Color.fromRGBO(228, 228, 240, 1),
                                size: 19.sp,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Settings',
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(242, 242, 250, 1),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w300),
                                    )),
                              )
                            ],
                          ),
                          Icon(
                            Iconsax.arrow_right_3,
                            color: Color.fromRGBO(228, 228, 240, 1),
                          )
                        ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Contact();
                    }));
                  },
                  child: Container(
                    height: 8.h,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.messages_3,
                                  color: Color.fromRGBO(228, 228, 240, 1),
                                  size: 19.sp,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text('Contact Us',
                                      style: GoogleFonts.workSans(
                                        textStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                242, 242, 250, 1),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300),
                                      )),
                                )
                              ],
                            ),
                            Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(228, 228, 240, 1),
                            )
                          ]),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FAQ();
                    }));
                  },
                  child: Container(
                    height: 8.h,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.message_question,
                                  color: Color.fromRGBO(228, 228, 240, 1),
                                  size: 19.sp,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text('FAQ',
                                      style: GoogleFonts.workSans(
                                        textStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                242, 242, 250, 1),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w300),
                                      )),
                                )
                              ],
                            ),
                            Icon(
                              Iconsax.arrow_right_3,
                              color: Color.fromRGBO(228, 228, 240, 1),
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ]),
    );
  }
}
