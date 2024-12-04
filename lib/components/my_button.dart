import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
@immutable
class my_button extends StatefulWidget {

  final Function()? onTaps;
  String  text;

   my_button({super.key,required this.onTaps,required this.text});

  @override
  State<my_button> createState() => _my_buttonState();
}

class _my_buttonState extends State<my_button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTaps,
      child: Container(
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
