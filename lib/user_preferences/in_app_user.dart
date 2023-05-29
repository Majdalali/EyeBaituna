import 'package:eyebaituna_app/models/user.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:get/get.dart';

class InAppUser extends GetxController {
  final Rx<User> _inAppUser = User(0, '', '', '').obs;

  User get user => _inAppUser.value;

  getUserInfo() async {
    User? getUserInfoLocalStorge = await RememberUser.readUserInfo();
    _inAppUser.value = getUserInfoLocalStorge!;
  }
}
