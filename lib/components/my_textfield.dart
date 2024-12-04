import 'dart:ui';

import 'package:flutter/material.dart';

class my_textfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const my_textfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
            //   borderSide: BorderSide.none,
            // ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
