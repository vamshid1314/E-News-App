import 'package:flutter/material.dart';

class InputFields extends StatelessWidget{

  final String inputText;
  final IconData? inputIcon;
  final TextEditingController? controller;

  const InputFields({
    super.key,
    required this.inputText,
    this.inputIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:controller,
      style: TextStyle(
        fontFamily:'MW',
        color: Colors.white,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        hintText: inputText,
        hintStyle: TextStyle(
          fontFamily:'MW',
          color: Colors.white,
          fontSize: 18,
        ),
        prefixIcon: inputIcon != null
            ? Icon(
          inputIcon,
          color: Colors.white,
        )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),

        ),
      ),
    );
  }

}