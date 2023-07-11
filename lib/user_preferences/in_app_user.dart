import 'package:eyebaituna_app/models/user.dart';
import 'package:eyebaituna_app/user_preferences/user_preferences.dart';
import 'package:get/get.dart';

class InAppUser extends GetxController {
  final Rx<User> _inAppUser =
      User(id: 0, username: '', email: '', password: '').obs;

  User get user => _inAppUser.value;

  getUserInfo() async {
    User? getUserInfoLocalStorage = await RememberUser.readUserInfo();
    _inAppUser.value = getUserInfoLocalStorage!;
  }
}
