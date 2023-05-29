// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ApiService {
  static const hostConn = 'http://192.168.0.183/eyeBaituna_api/';
  static const hostConnUser = '$hostConn/user';
  static const validateEmail = '$hostConn/user/validate_email.php';
  static const signup = '$hostConn/user/register.php';
  static const login = '$hostConn/user/login.php';
  static const banURLS = '$hostConn/user/ban_urls.php';
}
