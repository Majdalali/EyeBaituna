import 'dart:convert';

import 'package:eyebaituna_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUser {
  //! Save User info in local storage
  static Future<void> saveUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  //! Get user info from local storage
  static Future<User?> readUserInfo() async {
    User? currentUserInfo;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  //! Remove user info from local storage
  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }

  //! Check if intro screens have been seen
  static Future<bool> hasSeenIntroScreens() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('hasSeenIntroScreens') ?? false;
  }

  //! Set flag indicating intro screens have been seen
  static Future<void> setHasSeenIntroScreens(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('hasSeenIntroScreens', value);
  }

  //! Get pin code and store it
  static Future<void> savePinCode(String pinCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('pinCode', pinCode);
  }

  static Future<String?> readPinCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('pinCode');
  }
}
