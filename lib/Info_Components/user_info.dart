// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, prefer_if_null_operators

import 'package:eyebaituna_app/Info_Components/pinfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class UserInfoEditor extends StatefulWidget {
  const UserInfoEditor({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserInfoEditorState createState() => _UserInfoEditorState();
}

class _UserInfoEditorState extends State<UserInfoEditor> {
  final InAppUser _inAppUser = Get.put(InAppUser());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  void updateUserProfile() async {
    String newUsername = _usernameController.text.trim();
    String newEmail = _emailController.text.trim();
    String pincodeText = _pincodeController.text.trim();

    // Validate pincode using regex
    if (pincodeText.isNotEmpty) {
      RegExp pincodeRegex = RegExp(r'^\d{6}$');
      if (!pincodeRegex.hasMatch(pincodeText)) {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "Pincode should be 6 digits and only contain numbers",
        );
        return;
      }
    }

    String? newPincode = pincodeText.isNotEmpty ? pincodeText : null;

    // ignore: unused_local_variable
    bool hasChanges = false; // Flag to track if any changes were made

    if (newUsername.isNotEmpty) {
      hasChanges = true;
    }

    if (newEmail.isNotEmpty) {
      hasChanges = true;
    }

    if (newPincode != null) {
      hasChanges = true;
    }

    try {
      final _inAppUser = Get.find<InAppUser>();

      bool success = await ApiService.updateUserProfile(
        id: _inAppUser.user.id,
        username: newUsername,
        email: newEmail,
        pincode: newPincode,
      );

      if (success) {
        // Update the user information in the InAppUser instance
        if (newUsername.isNotEmpty) {
          _inAppUser.user.username = newUsername;
        }
        if (newEmail.isNotEmpty) {
          _inAppUser.user.email = newEmail;
        }
        if (newPincode != null) {
          _inAppUser.user.pincode = int.tryParse(newPincode);
        }

        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: 'User profile updated successfully',
        );
      } else {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "Failed to update user profile",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: 'Error occurred: $e',
      );
    }
  }

  Widget infoCard(
    IconData iconData,
    String userData,
    TextEditingController inputController,
  ) {
    inputController.text = userData;
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
                        SizedBox(
                          width: 70.w,
                          child: TextField(
                            controller: inputController,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: userData,
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCardPin(
    IconData iconData,
    String userData,
    TextEditingController inputController,
  ) {
    String initialValue = userData == "null" ? "" : userData;

    // Set the initial value of the text field
    inputController.text = initialValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
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
                          SizedBox(
                            width: 70.w,
                            child:
                                PinCodeTextField(controller: inputController),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(22, 23, 26, 1),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(35, 35, 54, 1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
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
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  infoCard(Iconsax.user, _inAppUser.user.username,
                      _usernameController),
                  SizedBox(height: 5),
                  infoCard(Icons.email_outlined, _inAppUser.user.email,
                      _emailController),
                  SizedBox(height: 5),
                  infoCardPin(Icons.pin_outlined,
                      _inAppUser.user.pincode.toString(), _pincodeController),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.tag_right,
                                  color: Color.fromRGBO(228, 228, 240, 1),
                                  size: 17.sp,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 200,
                                          child: Text(
                                            _inAppUser.user.id.toString(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 90.w,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: const [
                          Color.fromRGBO(157, 98, 217, 1),
                          Color.fromRGBO(98, 98, 217, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: updateUserProfile,
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
