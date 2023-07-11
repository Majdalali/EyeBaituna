import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PinCodeTextField extends StatefulWidget {
  final TextEditingController controller;

  const PinCodeTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PinCodeTextFieldState createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: _obscureText,
            controller: widget.controller,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter a PIN code",
              hintStyle: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromRGBO(101, 101, 118, 1),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget infoCardPin(
  IconData iconData,
  String userData,
  TextEditingController inputController,
) {
  inputController.text = userData == "null" ? "" : userData;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 8.h,
      decoration: const BoxDecoration(color: Color.fromRGBO(35, 35, 54, 1)),
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
                  color: const Color.fromRGBO(228, 228, 240, 1),
                  size: 17.sp,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PinCodeTextField(controller: inputController),
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
