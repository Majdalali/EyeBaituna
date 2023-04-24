import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginScreen();
}

class _LoginScreen extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Login'),
    );
  }
}
