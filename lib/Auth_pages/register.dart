import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Register'));
  }
}
